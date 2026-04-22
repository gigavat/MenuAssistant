import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/future_calls.dart';
import '../service_registry.dart';
import '../services/geo/ip_geo_service.dart';

/// Periodic worker that refreshes the offline DB-IP Lite country CSV.
///
/// DB-IP publishes a new monthly snapshot on the 1st. We re-fetch weekly
/// so the data stays within one release cycle without hammering their
/// mirror. Downloads go to `data/geo/dbip-country-lite.csv` (git-ignored).
///
/// Attribution: DB-IP is CC-BY 4.0. The landing `/legal` page must credit
/// "IP geolocation by DB-IP". See docs/legal/db-ip-attribution.md.
class DbIpUpdateFutureCall extends FutureCall {
  static const _refreshInterval = Duration(days: 7);

  /// DB-IP publishes files at this URL pattern:
  ///   https://download.db-ip.com/free/dbip-country-lite-YYYY-MM.csv.gz
  /// The `latest` alias is not stable — build the URL from current month.
  static String _downloadUrl([DateTime? now]) {
    final d = now ?? DateTime.now();
    final yyyy = d.year.toString().padLeft(4, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return 'https://download.db-ip.com/free/dbip-country-lite-$yyyy-$mm.csv.gz';
  }

  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    try {
      await _downloadLatest(session);
      // Invalidate the in-memory cache so next lookup re-reads from disk.
      await ServiceRegistry.instance.ipGeoService.reload();
    } catch (e, st) {
      session.log(
        'DbIpUpdateFutureCall failed: $e\n$st',
        level: LogLevel.warning,
      );
      // Fall through — we still reschedule so we retry next week.
    }

    await session.serverpod.futureCalls
        .callAtTime(DateTime.now().add(_refreshInterval))
        .dbIpUpdate
        .invoke(null);
  }

  Future<void> _downloadLatest(Session session) async {
    final dir = Directory(dbIpDataDir);
    await dir.create(recursive: true);

    // Try current month first; if 404 (e.g. snapshot not yet published for
    // the new month) fall back to previous month.
    final now = DateTime.now();
    var url = _downloadUrl(now);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 404) {
      final prev = DateTime(now.year, now.month - 1, 1);
      url = _downloadUrl(prev);
      response = await http.get(Uri.parse(url));
    }
    if (response.statusCode != 200) {
      throw Exception(
        'DB-IP download failed (${response.statusCode}): $url',
      );
    }

    final gzipped = response.bodyBytes;
    final csv = gzip.decode(gzipped);

    final targetPath = '$dbIpDataDir/$dbIpCountryCsvFile';
    final tmpPath = '$targetPath.tmp';
    await File(tmpPath).writeAsBytes(csv);
    await File(tmpPath).rename(targetPath);

    session.log(
      'DB-IP country CSV refreshed (${(csv.length / 1024 / 1024).toStringAsFixed(1)} MiB from $url)',
    );
  }
}
