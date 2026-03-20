import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mart_erp/common/constants/shared_constant.dart';
import 'package:mart_erp/config/dio/dio_client.dart';

import '../add_customer_model.dart';
import '../model/api_response_data.dart';

class AddCustomerService {
  static final Map<String, CancelToken> activeRequests = {};

  static Future<ApiResponseData> savenewCustomer(
    AddCustomerModel data,
  ) async {
    var customerHashData = AddCustomerModel.generateHashDataForCustomer(
        emailId: data.emailId!,
        mobileNo: data.mobileNo!,
        otp: data.otp!,
        name: data.name,
        address: data.address!,
        uniqueId: data.uniqueId!,);

    data = data.copyWith(addCustomerhashData: customerHashData);

    var formData = FormData.fromMap({
      'paraDataColl': jsonEncode(data.toJsonForSave()),
    });

    if (data.imagePath != null) {
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            data.imagePath!,
            filename: 'partyController.text.jpg',
          ),
        ),
      );
    }

    if (activeRequests.containsKey(data.uniqueId)) {
      return ApiResponseData(
        responseMSG: 'Request with this UUID is already in progress',
        isSuccess: false,
      );
    }
    // Create a new CancelToken for this request
    var cancelToken = CancelToken();
    activeRequests[data.uniqueId!] = cancelToken;

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString(SharedConstant.masterToken) ?? 
                  pref.getString(SharedConstant.accessToken);

      if (token == null || token.isEmpty) {
        return ApiResponseData(
          responseMSG: 'Authentication token not found. Please login again.',
          isSuccess: false,
          isNetworkError: false,
        );
      }

      var response = await dioClient.put(
        '/Customer/Register',
        data: formData,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data', // Correct header name
            'X-Idempotency-Key': data.uniqueId,
            'Authorization': 'Bearer $token',
          },
          extra: {'skipGlobalErrorHandling': true},
        ),
      );

      if (response.statusCode == 200 && response.data['IsSuccess'] == true) {
        var responseMsg = response.data['ResponseMSG']?.toString() ?? '';
        var isSuccess = response.data['IsSuccess'] == true;

        await pref.setBool(SharedConstant.userAlreadyRegistered, true);

        activeRequests.clear();
        return ApiResponseData(
          responseMSG: responseMsg,
          rId: response.data['Rid'] ??
              response.data['RId'] ??
              response.data['rid'],
          isSuccess: isSuccess,
          isNetworkError: false,
        );
      } else {
        var errorMessage = response.data['ResponseMSG']?.toString() ??
            'Unknown error occurred';
        bool isDulicate = errorMessage.toLowerCase().contains('duplicate');

        return ApiResponseData(
          responseMSG: errorMessage,
          isSuccess: false,
          isduplicate: isDulicate,
          isNetworkError: false,
        );
      }

      // Fallback for non-200 status codes
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return ApiResponseData(
          responseMSG: 'Request cancelled (newer request in progress)',
          isSuccess: false,
          isNetworkError: true,
        );
      }

      // Handle network or server errors
      var errorMessage = e.response?.data['ResponseMSG']?.toString() ??
          'Network Error (Slow or no internet)';

      // Optional: Clear all requests on persistent network failure (customize as needed)
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        activeRequests.clear(); // Systemic failure, clear all
      }

      return ApiResponseData(
        responseMSG: errorMessage,
        isSuccess: false,
        isNetworkError: true,
        isduplicate: false,
      );
    } catch (e) {
      EasyLoading.showError(
        'Something went wrong: $e',
        duration: const Duration(seconds: 3),
      );
      return ApiResponseData(
        responseMSG: 'Unexpected error',
        isSuccess: false,
        isNetworkError: true,
        isduplicate: false,
      );
    } finally {
      // Always remove this specific request from tracking
      activeRequests.remove(data.uniqueId);
    }
  }

  static String? getUniqueIdFromFormData(FormData data) {
    try {
      // Check fields first
      var field = data.fields.firstWhere(
        (field) => field.key == 'UniqueId',
        orElse: () => const MapEntry('', ''),
      );
      if (field.key.isNotEmpty) return field.value;

      return null;
    } catch (e) {
      return null;
    }
  }
}
