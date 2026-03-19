import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mart_erp/features/one_time_setup/service/crm_dioclient.dart';

import '../model/company_domain_detail/company_domain_detail.dart';
import '../model/domainrequestmodel.dart';
import 'crm_endpoints.dart';

class OneTimeSetup {
  static Future<CompanyDomainDetail?> getDomainDetail(
    Domainrequestmodel data,
  ) async {
    try {
      // Define your request data
      final Map<String, dynamic> requestData = data.toJson()
        ..removeWhere((key, value) => value == null)
        ..removeWhere((key, value) => value == null);
      log(requestData.toString());

      final response = await crmDioClient.post(
        CrmEndPoint.getKycDetail,
        data: requestData,
        options: Options(extra: {'skipGlobalErrorHandling': true}),
      );

      // Hide loading indicator when the API call is completed

      if (response.data['IsSuccess'] &&
          response.data['CompanyCode'] != null &&
          response.data['UrlName'] != null) {
        return CompanyDomainDetail.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      log('Unexpected error: $e');
    }
    return null;
  }
}
