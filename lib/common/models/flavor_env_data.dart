import 'package:shared_preferences/shared_preferences.dart';

class FlavorEnvData {
  final String companyName;
  final String dateFormat;
  final String logoPath;
  final String baseUrl;
  final String address;
  final String? dbCode;

  FlavorEnvData({
    required this.companyName,
    required this.dateFormat,
    required this.logoPath,
    required this.baseUrl,
    required this.address,
    required this.dbCode,
  });

  static Future<void> addToPreferences(FlavorEnvData flavorData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('companyName', flavorData.companyName);
    await prefs.setString('dateFormat', flavorData.dateFormat);
    await prefs.setString('logoPath', flavorData.logoPath);
    await prefs.setString('baseUrl', flavorData.baseUrl);
    await prefs.setString('address', flavorData.address);
    if (flavorData.dbCode != null) {
      await prefs.setString('dbCode', flavorData.dbCode!);
    }
  }
}