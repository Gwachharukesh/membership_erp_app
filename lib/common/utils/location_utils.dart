import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  // Default Kathmandu coordinates fallback
  static const double defaultLatitude = 27.7172;
  static const double defaultLongitude = 85.3240;

  /// Requests location permission and returns the position
  /// Returns default Kathmandu coordinates if:
  /// - Location services are disabled
  /// - Permission is denied
  /// - Unable to fetch position
  static Future<Map<String, double>> getLocationCoordinates() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return {'latitude': defaultLatitude, 'longitude': defaultLongitude};
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return {'latitude': defaultLatitude, 'longitude': defaultLongitude};
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied.');
        return {'latitude': defaultLatitude, 'longitude': defaultLongitude};
      }

      // Get current position
      try {
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );

        debugPrint(
          'Location obtained: ${position.latitude}, ${position.longitude}',
        );

        return {'latitude': position.latitude, 'longitude': position.longitude};
      } catch (positionError) {
        // If unable to get position, use default coordinates
        debugPrint('Unable to get position, using default: $positionError');
        return {'latitude': defaultLatitude, 'longitude': defaultLongitude};
      }
    } catch (e) {
      debugPrint('Location error: $e');
      return {'latitude': defaultLatitude, 'longitude': defaultLongitude};
    }
  }

  /// Get location as a string format "latitude,longitude"
  static Future<String> getLocationString() async {
    final coords = await getLocationCoordinates();
    return '${coords['latitude']},${coords['longitude']}';
  }

  /// Check if location services are enabled
  static Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
