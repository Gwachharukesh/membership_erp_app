import 'package:dio/dio.dart';
import 'package:mart_erp/common/constants/shared_constant.dart';
import 'package:mart_erp/config/dio/dio_client.dart';
import 'package:mart_erp/features/customer/model/api_response_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_detail_model.dart';

class UserDetailService {
  /// Fetch user details from the API
  ///
  /// Endpoint: /General/GetUserDetail
  /// Returns: UserDetailModel with API response
  static Future<ApiResponseData> getUserDetail({required int userId}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString(SharedConstant.masterToken);

      final response = await dioClient.get(
        '/General/GetUserDetail',
        queryParameters: {'userId': userId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          extra: {'skipGlobalErrorHandling': false},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Parse the response into UserDetailModel
        final userDetail = UserDetailModel.fromJson(response.data);

        if (userDetail.isSuccess == true) {
          return ApiResponseData(
            responseMSG: userDetail.responseMSG ?? 'Success',
            isSuccess: true,
            userData: userDetail,
          );
        } else {
          return ApiResponseData(
            responseMSG:
                userDetail.responseMSG ?? 'Failed to fetch user details',
            isSuccess: false,
            userData: userDetail,
          );
        }
      }

      return ApiResponseData(
        responseMSG: 'No data received from server',
        isSuccess: false,
      );
    } on DioException catch (e) {
      String errorMessage = 'An error occurred';

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.response?.statusCode == 401) {
        errorMessage = 'Unauthorized. Please login again.';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'User not found.';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Server error. Please try again later.';
      } else if (e.message?.contains('SocketException') == true) {
        errorMessage = 'Network error. Please check your connection.';
      } else {
        errorMessage = e.message ?? 'Unknown error occurred';
      }

      return ApiResponseData(
        responseMSG: errorMessage,
        isSuccess: false,
        isNetworkError: true,
      );
    } catch (e) {
      return ApiResponseData(
        responseMSG: 'Unexpected error: ${e.toString()}',
        isSuccess: false,
      );
    }
  }
}
