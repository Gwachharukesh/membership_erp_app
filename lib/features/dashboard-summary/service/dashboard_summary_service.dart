import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/shared_constant.dart';
import '../../../config/dio/dio_client.dart';
import '../model/mart_dashboard_model.dart';

Future<DashboardSummaryModel> getDashboardSummary() async {
  Response<dynamic>? response;
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString(SharedConstant.accessToken);

    response = await dioClient.post(
      '/Customer/GetSalesPoint',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    //
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data['IsSuccess']) {
      return DashboardSummaryModel.fromJson(response.data);
      // En; // Ensure you convert the mapped result to a list if required
    }
    EasyLoading.showError(
      response.data?['ResponseMSG'] ?? 'Failed to load dashboard summary',
      duration: const Duration(seconds: 3),
    );
    return DashboardSummaryModel();
  } catch (e) {
    EasyLoading.showError(
      response?.data?['ResponseMsg'] ?? 'An error occurred',
      duration: const Duration(seconds: 3),
    );
    return DashboardSummaryModel();
  }
}



/*
{
     "LedgerId": 0,
     "DrPoint": 0.0,
     "CrPoint": 0.0,
     "BalPoint": 0.0,
     "LastInvoiceNo": null,
     "LastInvoiceAmt": 0.0,
     "LastInvoiceDate": "0001-01-01T00:00:00",
     "LastInvoiceMiti": null,
     "LastSalesBeforeDays": 0,
     "ResponseMSG": "Could not find stored procedure 'usp_GetSalesPointSummary'.",
     "IsSuccess": false
}

 */