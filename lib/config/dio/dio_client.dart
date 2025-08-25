import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';

import '../../common/constants/end_points.dart';
import 'auth_inceptor.dart';
import 'retry_inceptor.dart';

var myname = 'rukesh';
// final Dio dioClient = Dio(
//   BaseOptions(
//     baseUrl: Endpoints.baseUrl + Endpoints.version,
//     connectTimeout: Endpoints.connectionTimeout,
//     receiveTimeout: Endpoints.receiveTimeout,
//     responseType: ResponseType.json,
//   ),
// )..interceptors.add(AuthorizationInterceptor());

// Dio dioClient = Dio();
Dio dioClient = Dio(
  BaseOptions(
    baseUrl: '${Endpoints.baseUrl}/${Endpoints.version}',
    connectTimeout: const Duration(milliseconds: Endpoints.connectionTimeout),
    receiveTimeout: const Duration(milliseconds: Endpoints.receiveTimeout),
  ),
)..interceptors.add(ChuckerDioInterceptor());

final Dio dioClientWithoutVersion =
    Dio(
        BaseOptions(
          connectTimeout: const Duration(
            milliseconds: Endpoints.connectionTimeout,
          ),
          receiveTimeout: const Duration(
            milliseconds: Endpoints.receiveTimeout,
          ),
        ),
      )
      ..interceptors.add(CustomRetryInterceptor(dioClient))
      ..interceptors.add(ChuckerDioInterceptor())
      ..interceptors.add(AuthorizationInterceptor());

Dio dioClientForPreLogin = Dio(
  BaseOptions(
    baseUrl: '${Endpoints.baseUrl}/${Endpoints.version}',
    connectTimeout: const Duration(seconds: Endpoints.connectionTimeout),
    receiveTimeout: const Duration(seconds: Endpoints.receiveTimeout),
  ),
);
// ..interceptors.addAll([BranchInterceptor()]);

class DioClientService {
  static Future<List<T>> postApi<T>(
    String url, {
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      // Make the POST request
      var response = await dioClient.post(url, data: data);

      // Extract response data
      var responseData = response.data;

      if (responseData['IsSuccess'] == true) {
        var dataColl = responseData['DataColl'];
        if (dataColl == null) {
          return []; // No data found, return an empty list
        }
        return (dataColl as List)
            .map((e) => fromJson(e as Map<String, dynamic>))
            .toList(); // Parse each item using fromJson
      } else {
        // Return empty list or throw an error based on use case
        throw Exception(responseData['ResponseMSG'] ?? 'Unknown error');
      }
    } catch (e) {
      // Error handling
      throw Exception('Error while making POST request: $e');
    }
  }
}
