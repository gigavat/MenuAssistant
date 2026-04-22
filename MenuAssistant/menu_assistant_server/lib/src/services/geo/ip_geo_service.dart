import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Directory (relative to server cwd) where the DB-IP data file lives.
/// Kept out of git via .gitignore — populated by [DbIpUpdateFutureCall].
const dbIpDataDir = 'data/geo';

/// Filename under [dbIpDataDir] where the latest country CSV is stored
/// (uncompressed, UTF-8). The update job atomically renames new downloads
/// into this path.
const dbIpCountryCsvFile = 'dbip-country-lite.csv';

class IpGeoResult {
  final String? countryCode;
  final String? cityName;
  final double? latitude;
  final double? longitude;

  IpGeoResult({
    this.countryCode,
    this.cityName,
    this.latitude,
    this.longitude,
  });
}

/// Offline IP → geo lookup backed by the DB-IP Lite country dataset
/// (CC-BY 4.0, refreshed monthly). Lookup is an in-memory binary search
/// over ~300K sorted IPv4 ranges.
///
/// Limitations for Sprint 4.6:
/// - **Country-level only.** City-level data requires the mmdb variant
///   (~300MB uncompressed, needs a binary-tree reader). Deferred — the
///   cityHint field on [IpGeoResult] stays null until a follow-up sprint.
/// - **IPv4 only.** IPv6 rows in the CSV are ignored; IPv6 lookups
///   return null. Enough for the dedup fallback path which just needs
///   country scoping.
///
/// Attribution requirement (CC-BY 4.0): the landing `/legal` page must
/// credit "IP geolocation by DB-IP". Tracked in `docs/legal/db-ip-attribution.md`.
class IpGeoService {
  /// Loaded once on first call (or after an explicit [reload]). The list is
  /// sorted ascending by [_IpRange.fromIp] — lookup is `O(log n)`.
  List<_IpRange>? _ranges;

  /// Path to the CSV file, resolved relative to server cwd.
  String get csvPath => '$dbIpDataDir/$dbIpCountryCsvFile';

  /// Whether the underlying CSV data file is present on disk.
  bool get isDataAvailable => File(csvPath).existsSync();

  /// Looks up the country code for [ip]. Returns null when:
  /// - [ip] is not a valid IPv4 address
  /// - the data file hasn't been downloaded yet
  /// - no range contains the address (rare, usually reserved space)
  Future<IpGeoResult?> lookup(String ip) async {
    final v4 = _parseIpv4(ip);
    if (v4 == null) return null;

    if (_ranges == null) {
      if (!isDataAvailable) return null;
      _ranges = await _loadRanges(csvPath);
    }

    final ranges = _ranges!;
    // Binary search for the last range whose fromIp <= v4.
    var lo = 0, hi = ranges.length - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (ranges[mid].fromIp <= v4) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    if (lo < 0) return null;
    final r = ranges[lo];
    if (v4 < r.fromIp || v4 > r.toIp) return null;
    return IpGeoResult(countryCode: r.countryCode);
  }

  /// Re-reads the CSV file. Call after [DbIpUpdateFutureCall] replaces it
  /// with a fresh monthly snapshot.
  Future<void> reload() async {
    if (!isDataAvailable) {
      _ranges = null;
      return;
    }
    _ranges = await _loadRanges(csvPath);
  }

  /// CSV schema (DB-IP Lite country): `from_ip,to_ip,country_code`.
  /// IPv6 rows (containing ':') are skipped — see class doc.
  static Future<List<_IpRange>> _loadRanges(String path) async {
    final out = <_IpRange>[];
    final lines = File(path)
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    await for (final line in lines) {
      if (line.isEmpty) continue;
      // DB-IP CSV wraps values in double quotes: "1.0.0.0","1.0.0.255","US"
      final parts = _splitCsvLine(line);
      if (parts.length < 3) continue;
      if (parts[0].contains(':') || parts[1].contains(':')) continue;
      final from = _parseIpv4(parts[0]);
      final to = _parseIpv4(parts[1]);
      if (from == null || to == null) continue;
      out.add(_IpRange(
        fromIp: from,
        toIp: to,
        countryCode: parts[2],
      ));
    }
    out.sort((a, b) => a.fromIp.compareTo(b.fromIp));
    return out;
  }

  /// Minimal CSV splitter for the DB-IP format (3 quoted fields, no embedded
  /// commas or quotes). Keeps the file-load path dependency-free.
  static List<String> _splitCsvLine(String line) {
    final result = <String>[];
    var inQuotes = false;
    var buf = StringBuffer();
    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        inQuotes = !inQuotes;
      } else if (ch == ',' && !inQuotes) {
        result.add(buf.toString());
        buf = StringBuffer();
      } else {
        buf.write(ch);
      }
    }
    result.add(buf.toString());
    return result;
  }

  static int? _parseIpv4(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return null;
    var result = 0;
    for (final p in parts) {
      final n = int.tryParse(p);
      if (n == null || n < 0 || n > 255) return null;
      result = (result << 8) | n;
    }
    return result;
  }
}

class _IpRange {
  final int fromIp;
  final int toIp;
  final String countryCode;

  _IpRange({
    required this.fromIp,
    required this.toIp,
    required this.countryCode,
  });
}

/// Convenience extractor for Serverpod endpoints. Returns the client IP
/// from the session's HTTP headers, respecting common proxy headers.
/// Returns null when the session has no inbound request (e.g. future calls).
String? extractClientIp(Session session) {
  if (session is! MethodCallSession) return null;
  final req = session.request;
  final xf = req.headers['x-forwarded-for']?.firstOrNull;
  if (xf != null && xf.isNotEmpty) {
    return xf.split(',').first.trim();
  }
  final cf = req.headers['cf-connecting-ip']?.firstOrNull;
  if (cf != null && cf.isNotEmpty) return cf;
  return req.connectionInfo.remote.address.toString();
}
