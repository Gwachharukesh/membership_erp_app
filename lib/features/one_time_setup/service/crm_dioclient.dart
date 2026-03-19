import 'package:dio/dio.dart';
import 'package:mart_erp/features/one_time_setup/service/crm_auth_interceptor.dart';
import 'package:mart_erp/features/one_time_setup/service/crm_endpoints.dart';

import '../../../common/constants/end_points.dart';
//import 'package:chucker_flutter/chucker_flutter.dart';

//import 'package:pretty_dio_logger/pretty_dio_logger.dart';
Dio crmDioClient =
    Dio(
        BaseOptions(
          baseUrl: CrmEndPoint.baseUrl,
          connectTimeout: const Duration(seconds: Endpoints.connectionTimeout),
          receiveTimeout: const Duration(seconds: Endpoints.receiveTimeout),
        ),
      )
      ..interceptors.addAll([
        CRMAuthorizationInterceptor(),
        //ChuckerDioInterceptor(),
        // PrettyDioLogger(
        //    requestHeader: false,
        //     requestBody: true,
        //     responseBody: false,
        //     responseHeader: false,
        //     error: true,
        //     compact: true,
        //)
      ]);

Dio dioClientWithoutInterceptor =
    Dio(
        BaseOptions(
          baseUrl: '${Endpoints.baseUrl}/${Endpoints.version}',
          connectTimeout: const Duration(seconds: Endpoints.connectionTimeout),
          receiveTimeout: const Duration(seconds: Endpoints.receiveTimeout),
        ),
      )
      ..interceptors.addAll([
        // AuthorizationInterceptor(),
        //ChuckerDioInterceptor(),
        // PrettyDioLogger(
        //    requestHeader: false,
        //     requestBody: true,
        //     responseBody: false,
        //     responseHeader: false,
        //     error: true,
        //     compact: true,
        //)
      ]);
