import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class CustomRetryInterceptor extends Interceptor {
  CustomRetryInterceptor(Dio dioClient) {
    dioClient.interceptors.add(
      RetryInterceptor(
        dio: dioClient,
        logPrint: (message) => log(message), // Use dart:developer log
        retryDelays: const [
          Duration(seconds: 1), // Delay before 1st retry
          Duration(seconds: 2), // Delay before 2nd retry
          Duration(seconds: 3), // Delay before 3rd retry
        ],
        retryEvaluator: (DioException error, int attempt) {
          // Don’t retry PUT requests (non-idempotent updates)
          if (error.requestOptions.method == 'PUT') {
            return false;
          }

          // Retry on network-related errors
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError ||
              (error.type == DioExceptionType.unknown &&
                  error.error is SocketException)) {
            log('Retrying attempt #$attempt due to network error: ${error.message}');
            return true;
          }

          // Retry on specific HTTP status codes
          var statusCode = error.response?.statusCode;
          if (statusCode == 503 || statusCode == 429) {
            log('Retrying attempt #$attempt due to status code: $statusCode');
            return true;
          }

          // Example: Retry if product list is empty (customize as needed)
          // if (error.response?.data is Map && error.response?.data['products'] is List) {
          //   final products = error.response?.data['products'] as List;
          //   if (products.isEmpty) {
          //     log('Retrying attempt #$attempt due to empty product list');
          //     return true;
          //   }
          // }

          return false; // Don’t retry other cases
        },
      ),
    );
  }
}
