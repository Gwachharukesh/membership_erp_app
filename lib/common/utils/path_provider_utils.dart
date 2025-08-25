import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PathProviderUtils {
  /// Returns the path for the Download folder, platform-specific
  static Future<String> getDownloadPath() async {
    try {
      // Request storage permissions if needed
      // await _requestStoragePermission();

      // Check platform and fetch the directory path accordingly
      Directory directory = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await _getAndroidDownloadDirectory();

      // Create subdirectory within download folder
      directory = Directory('${directory.path}/Pivotal');
      return await _ensureDirectoryExists(directory);
    } catch (e) {
      log('Error getting download path: $e');
      String? path = await getApplciationDirectory('Pivotal');
      return path ?? '';
    }
  }

  /// Returns the temporary directory path
  static Future<String> getTemporaryPath() async {
    try {
      var tempDir = await getTemporaryDirectory();
      var specificTempDir = Directory('${tempDir.path}/PivotalTemp');
      return await _ensureDirectoryExists(specificTempDir);
    } catch (e) {
      if (kDebugMode) {
        log('Error getting temporary path: $e');
      }
      return (await getApplicationDocumentsDirectory()).path;
    }
  }

  /// Returns a specific application directory path, creates it if not exists
  static Future<String?> getApplciationDirectory(String folderName) async {
    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      var specificDir = Directory('${appDocDir.path}/$folderName');
      return await _ensureDirectoryExists(specificDir);
    } catch (e) {
      log('Error getting application directory: $e');
      showException(e.toString());
    }
    return null;
  }

  /// Helper method to handle the creation of directories
  static Future<String> _ensureDirectoryExists(Directory directory) async {
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory.path;
  }

  /// Helper method for getting the Android download directory
  static Future<Directory> _getAndroidDownloadDirectory() async {
    Directory directory;

    // Check if storage permission is granted
    if (Platform.isAndroid &&
        (await Permission.storage.isGranted ||
            await Permission.storage.request().isGranted)) {
      if (await _isBelowAndroid10()) {
        // For Android versions below 10 (API 29), use direct path
        directory = Directory('/storage/emulated/0/Download');
      } else {
        // For Android 10 and above, use public storage or scoped storage
        directory = await _getPublicStorageDirectory();
      }

      if (!await directory.exists()) {
        // Fallback to external storage directory
        directory = await getExternalStorageDirectory() ??
            Directory('/storage/emulated/0/Download');
      }
    } else {
      // Fallback to app's document directory
      var dir = await getApplicationDocumentsDirectory();
      directory = Directory('${dir.path}/Download');
    }
    return directory;
  }

  /// Check if the device is running Android 10 (API 29) or lower
  static Future<bool> _isBelowAndroid10() async {
    var deviceInfo = DeviceInfoPlugin();
    var androidInfo = await deviceInfo.androidInfo;

    // Compare the Android API level
    return androidInfo.version.sdkInt < 29;
  }

  /// Example of getting public storage directory for scoped storage
  static Future<Directory> _getPublicStorageDirectory() async {
    return Directory('/storage/emulated/0/Download'); // Adjust this as needed
  }

  /// Check if the device is running Android 10 (API 29) or lower

  /// Access public storage using MediaStore for Android 10+

  /// Requests the required permissions for accessing external storage
  static Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isDenied) {
        // Request permission if denied
        await Permission.storage.request();
      }

      if (await Permission.storage.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  /// Custom error handler
  static void showException(String e) {
    // Log and handle the exception as needed
    log('Error handled: $e');
  }
}
