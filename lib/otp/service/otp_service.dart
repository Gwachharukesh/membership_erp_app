import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mart_erp/common/constants/end_points.dart';
import 'package:mart_erp/common/constants/shared_constant.dart';
import 'package:mart_erp/config/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_response_model.dart';
import '../model/check_otp_validation_model.dart';
import '../model/otp_genetate_model.dart';

class OtpService {
  static Future<ApiResponseModel> generateOtp({
    required OtpGenerateModel otpData,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token =
          pref.getString(SharedConstant.masterToken) ??
          pref.getString(
            SharedConstant.accessToken,
          ); // Fallback to accessToken if masterToken not set

      log(otpData.toJson().toString());

      var response = await dioClient.post(
        Endpoints.generateOtp,
        data: jsonEncode(otpData.toJson()),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['IsSuccess']) {
        return ApiResponseModel.fromJson(response.data);
      } else {
        return ApiResponseModel.failed;
      }
    } on DioException catch (err) {
      return ApiResponseModel(isSuccess: false, responseMsg: err.toString());
    } catch (e) {
      return ApiResponseModel.failed;
    }
  }

  static Future<ApiResponseModel> verifyOTP({
    required OtpValidationRequestModel requestData,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token =
          pref.getString(SharedConstant.masterToken) ??
          pref.getString(
            SharedConstant.accessToken,
          ); // Fallback to accessToken if masterToken not set
      log('###############################');
      log('Genetated request data for otp');
      log(requestData.toJson().toString());

      var response = await dioClient.post(
        Endpoints.verifyOtp,
        data: jsonEncode(requestData.toJson()),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['ResponseMSG'] == 'Valid OTP') {
        EasyLoading.showSuccess(
          response.data['ResponseMSG'],
          duration: const Duration(seconds: 5),
        );
        return ApiResponseModel.fromJson(response.data);
      } else {
        EasyLoading.showSuccess(
          response.data['ResponseMSG'],
          duration: const Duration(seconds: 5),
        );
        return ApiResponseModel.failed;
      }
    } on DioException catch (err) {
      return ApiResponseModel(isSuccess: false, responseMsg: err.toString());
    } catch (e) {
      return ApiResponseModel.failed;
    }
  }
}
