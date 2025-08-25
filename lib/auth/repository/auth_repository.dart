import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:membership_erp_app/config/dio/dio_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/shared_constant.dart';
import '../../common/constants/shared_pref_initialization.dart';
import '../enums/user_type_enum.dart';
import '../models/token_models.dart';

class AuthRepository {
  Future<TokenModel?> signin({
    required String username,
    required String password,
    required bool isForMasterToken,
  }) async {
    var appVersion = await loadAppVersion();

    try {
      var response = await dioClient.post(
        'token',
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'userName': username,
          'password': password,
          'grant_type': 'password',
          // 'dbName': 'Pivotal_3035_v1',
          'appVer': appVersion,
        },
      );
      return _handleResponse(response, username, password, isForMasterToken);
    } on DioException catch (e) {
      if (e.response != null) {}
    } catch (e) {
      EasyLoading.showToast(
        'An unexpected error occurred: $e',
        toastPosition: EasyLoadingToastPosition.center,
      );
    } finally {
      log('Token request completed');
    }
    return null;
  }

  static Future<String> loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  static Future<TokenModel?> _handleResponse(
    Response response,
    String userName,
    String password,
    bool? isForMasterToken,
  ) async {
    if (response.statusCode == 200) {
      var tokenData = TokenModel.fromJson(response.data);

      var user = UserType.values.firstWhere(
        (user) =>
            user.title?.toLowerCase() == tokenData.userType?.toLowerCase(),
        orElse: () => UserType.member,
      );

      (isForMasterToken ?? false)
          ? await saveMasterToken(tokenData)
          : await _saveSecureData(tokenData, user, userName, password);

      return TokenModel.fromJson(response.data);
    } else {
      //   _showErrorToast(response.statusCode, response.data);
    }
    return null; // Return null if response is not successful
  }

  static saveMasterToken(TokenModel tokenData) async {
    if (tokenData.accessToken != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(SharedConstant.masterToken, tokenData.accessToken!);
    }
  }

  static Future<void> _saveSecureData(
    TokenModel tokenData,
    UserType user,
    String userName,
    String password,
  ) async {
    try {
      var sharedPrefs = await SharedPreferences.getInstance();

      Future<void> setPref(String key, String? value) async {
        if (value != null) await sharedPrefs.setString(key, value);
      }

      await sharedPrefs.setBool(SharedConstant.userAlreadyRegistered, true);

      log(
        'user Registration Status ${sharedPrefs.getBool(SharedConstant.userAlreadyRegistered)}',
      );

      await setPref(SharedConstant.accessToken, tokenData.accessToken);
      await setPref(SharedConstant.refreshToken, tokenData.refreshToken);
      await setPref(SharedConstant.userType, tokenData.userType);
      await setPref(SharedConstant.expiresIn, tokenData.expires?.toString());
      await setPref(SharedConstant.userId, tokenData.userId);
      await setPref(SharedConstant.loginUserName, userName);
      await setPref(SharedConstant.loginPassword, password);
      await setPref(SharedConstant.userName, tokenData.userName);
      await setPref(SharedConstant.customerCode, tokenData.customerCode);
      await setPref(SharedConstant.expires, tokenData.expires?.toString());

      await setPref(
        SharedConstant.loginDateTime,
        tokenData.curDateTime?.toString(),
      );
      await setPref(
        SharedConstant.todayDate,
        tokenData.curDateTime?.toString(),
      );
      await sharedPrefs.setInt(SharedConstant.userTypeId, user.id ?? 1);
    } catch (e, stackTrace) {
      debugPrint("Error saving secure data: $e\n$stackTrace");
    }
  }

  static Future<void> _removeSecureData() async {
    await SharedPreferencesService().remove(SharedConstant.accessToken);
    await SharedPreferencesService().remove(SharedConstant.refreshToken);
    await SharedPreferencesService().remove(SharedConstant.userType);
    await SharedPreferencesService().remove(SharedConstant.userId);
    await SharedPreferencesService().remove(SharedConstant.loginPassword);
    await SharedPreferencesService().remove(SharedConstant.userName);
    await SharedPreferencesService().remove(SharedConstant.userTypeId);
    await SharedPreferencesService().remove(SharedConstant.customerCode);
    await SharedPreferencesService().remove(SharedConstant.expiredIn);
  }

  Future<void> _clearUserDataOnLogout() async {
    await _removeSecureData();
    // Clear any other user-related data if needed
  }

  Future<TokenModel> refreshAccessToken(
    String? refreshToken,
    String? userId,
  ) async {
    try {
      var response = await dioClient.post(
        'token',
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'userId': userId,
        },
      );

      TokenModel newTokenData = TokenModel.fromJson(response.data);

      return newTokenData;
    } on DioException catch (err) {
      var errorMessage = err.message.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  /// update user password
  static Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      var response = await dioClient.post(
        'General/UpdatePwd',
        data: {'oldPwd': oldPassword, 'newPwd': newPassword},
      );
      if (response.statusCode == 200 && response.data['IsSuccess'] as bool) {
        EasyLoading.showSuccess(
          'Password Change Success',
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        EasyLoading.showToast(
          response.data['ResponseMSG'],
          duration: const Duration(seconds: 2),
          toastPosition: EasyLoadingToastPosition.bottom,
        );
        return false;
      }
    } on DioException catch (err) {
      EasyLoading.showToast(
        err.response?.data['ResponseMSG'] ?? 'Something Went Wrong',
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    }
    return false;
  }
}
