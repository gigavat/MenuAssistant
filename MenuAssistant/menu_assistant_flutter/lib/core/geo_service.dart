import 'dart:io' show File, Platform;

import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:native_exif/native_exif.dart';

/// Wraps `geolocator` + EXIF extraction into a tiny façade that the UI
/// layer (AppState, AddMenu flow, Onboarding slide 2) consumes directly.
///
/// Permission checks funnel through this class so we can later add
/// telemetry or mocking without touching callers.
class GeoService {
  /// Checks current permission then prompts if still undetermined.
  /// Returns the resolved [LocationPermission] so callers can branch on
  /// `deniedForever` (send user to settings) vs plain `denied`.
  Future<LocationPermission> requestPermission() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return perm;
  }

  /// Returns the current device position or null when location services
  /// are off, permission denied, or the platform timed out. Never throws —
  /// consumers don't need to wrap the call.
  Future<Position?> getCurrentPosition({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return null;
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeout,
        ),
      );
    } catch (e, st) {
      debugPrint('GeoService.getCurrentPosition error: $e\n$st');
      return null;
    }
  }

  /// Tries to pull GPS lat/lng out of an image's EXIF metadata. Used as a
  /// fallback when the user denied runtime location (e.g. they took the
  /// photo earlier and granted camera-only permission).
  ///
  /// Strategy:
  /// - On iOS/Android, use [Exif.fromPath] which is fastest (no full read).
  /// - Elsewhere (desktop / web), fall back to the pure-Dart `exif`
  ///   package decoding the bytes in-memory.
  Future<({double? lat, double? lng})> extractExifGps({
    Uint8List? bytes,
    String? filePath,
  }) async {
    try {
      if (!kIsWeb &&
          filePath != null &&
          (Platform.isIOS || Platform.isAndroid)) {
        final exif = await Exif.fromPath(filePath);
        try {
          final coords = await exif.getLatLong();
          if (coords != null) {
            return (lat: coords.latitude, lng: coords.longitude);
          }
        } finally {
          await exif.close();
        }
      }

      final payload =
          bytes ?? (filePath == null ? null : await File(filePath).readAsBytes());
      if (payload == null) return (lat: null, lng: null);
      final tags = await readExifFromBytes(payload);

      final lat = _dmsToDecimal(
        tags['GPS GPSLatitude'],
        tags['GPS GPSLatitudeRef']?.printable,
      );
      final lng = _dmsToDecimal(
        tags['GPS GPSLongitude'],
        tags['GPS GPSLongitudeRef']?.printable,
      );
      return (lat: lat, lng: lng);
    } catch (e, st) {
      debugPrint('GeoService.extractExifGps error: $e\n$st');
      return (lat: null, lng: null);
    }
  }

  static double? _dmsToDecimal(IfdTag? tag, String? ref) {
    if (tag == null || tag.values.length < 3) return null;
    double toDouble(dynamic v) {
      if (v is Ratio) return v.numerator / v.denominator;
      if (v is num) return v.toDouble();
      return 0.0;
    }

    final list = tag.values.toList();
    final degrees = toDouble(list[0]);
    final minutes = toDouble(list[1]);
    final seconds = toDouble(list[2]);
    var decimal = degrees + minutes / 60.0 + seconds / 3600.0;
    if (ref == 'S' || ref == 'W') decimal = -decimal;
    return decimal;
  }
}
