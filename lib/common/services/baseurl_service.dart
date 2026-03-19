import 'package:shared_preferences/shared_preferences.dart';

class BaseurlService {
  static Future<void> updateBaseUrl(String baseUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', baseUrl);
  }
}