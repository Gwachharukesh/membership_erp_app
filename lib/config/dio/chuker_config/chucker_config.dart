import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/shared_constant.dart';

class ChuckerEnabler {
  static const _enabledKey = SharedConstant.showChucker;
  static const secretPassword = 'DYNAMICALmost10';

  static Future<bool> isEnabled() async {
    try {
      if (!kReleaseMode) {
        log('ChuckerEnabler: Debug mode, returning true');
        return true;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool enabled = prefs.getBool(_enabledKey) ?? false;
      log('ChuckerEnabler: Release mode, enabled = $enabled');
      return enabled;
    } catch (e) {
      return false;
    }
  }

  static Future<void> enableChucker(bool enable) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_enabledKey, enable);
    } catch (e) {
      return;
    }

    // You might need to restart the app for changes to take effect
  }

  static Future<bool> compareKey(String enteredKey) async {
    return secretPassword == enteredKey;
  }

  static restart() async {
    await Restart.restartApp();
  }
}
