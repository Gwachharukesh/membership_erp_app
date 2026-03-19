import 'package:dio/dio.dart';

class CRMAuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add CRM headers
    options.headers['CRM'] = 'Crm\$2023#LiveApi';
    super.onRequest(options, handler);
  }
}