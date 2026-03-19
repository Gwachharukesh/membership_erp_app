import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class PlatformExceptionInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle Dio errors
    // You can customize this to handle specific Dio errors if needed
    if (err.error is PlatformException) {
      // If the error is a platform exception, handle it accordingly
      var platformException = err.error! as PlatformException;
      // Pass the platform exception to Flutter code using a platform channel
      _handlePlatformException(platformException);
    } else {
      // For other Dio errors, you can handle them as needed
    }

    // Pass the error to the next error interceptor
    handler.next(err);
  }

  void _handlePlatformException(PlatformException exception) {}
}
