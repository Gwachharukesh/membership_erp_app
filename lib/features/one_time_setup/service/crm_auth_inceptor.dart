import 'package:dio/dio.dart';
import 'package:mart_erp/features/one_time_setup/service/crm_endpoints.dart';

class CRMAuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // adds the access-token with the header
    options.headers.addAll({
      CrmEndPoint.crmHeaderKey: CrmEndPoint.crmHeaderValue,
    });

    // continue with the request
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // final apiKey = await secureStorage.read(key: 'accessToken');
    handler.next(response);
    // adds the access-token with the header
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      /*  final userDertailHiveBox =
          Hive.box<TokenModel>(// 3rd step  need to open hive to use
              HiveConstants.tokenDetails);

      final tokenDetailfromHive = userDertailHiveBox.values;
      final refreshtToken = tokenDetailfromHive.first.refreshToken;
      if(refreshtToken!.isEmpty){
        
      }
*/
    }
    handler.next(err);
    if (err.type == DioExceptionType.connectionTimeout &&
        err.type == DioExceptionType.connectionError) {}
    // adds the access-token with the header
  }
}
