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

// class BranchInterceptor extends Interceptor {
//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     var companyDetail =
//         Hive.box<CompanyDomainDetail>(HiveConstants.companyDomainDetail);
//     var companyDomainDetailfromHive =
//         companyDetail.get(HiveConstants.companyDomainDetail);
//     options.headers['Content-Type'] = 'application/json';
//     Map<String, dynamic> data = options.data ?? {};
//     data['branchCode'] = Endpoints.branchId != 0
//         ? Endpoints.branchId
//         : companyDomainDetailfromHive?.branchId;

//     options.data = data;

//     super.onRequest(options, handler);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) async {
//     // final apiKey = await secureStorage.read(key: 'accessToken');
//     handler.next(response);
//     // adds the access-token with the header
//   }
// }
