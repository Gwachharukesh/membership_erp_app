import 'package:dio/dio.dart';
import '../models/payment_models.dart';
import '../utils/payment_config.dart';
import '../utils/signature_generator.dart';

class PaymentException implements Exception {
  final String message;
  final List<NpsApiError> errors;

  const PaymentException(this.message, [this.errors = const []]);

  @override
  String toString() => 'PaymentException: $message';
}

/// Low-level repository that performs all HTTP calls to OnePG APIs.
///
/// Each method maps to one integration step:
///   [getInstruments]         → Step 1 – GetPaymentInstrumentDetails
///   [getServiceCharge]       → Step 2 – GetServiceCharge
///   [getProcessId]           → Step 3 – GetProcessId
///   [buildGatewayHtml]       → Step 4 – Gateway redirect HTML
///   [checkTransactionStatus] → Step 5 – CheckTransactionStatus
class PaymentRepository {
  final Dio _dio;

  PaymentRepository({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': SignatureGenerator.basicAuth(
                  PaymentConfig.authUsername,
                  PaymentConfig.authPassword,
                ),
              },
            ));

  Future<Map<String, dynamic>> _post(
      String url, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: body,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      throw PaymentException(
        e.response?.statusMessage ?? 'Network error: ${e.message}',
      );
    } on FormatException catch (e) {
      throw PaymentException('Malformed response: ${e.message}');
    }
  }

  // Step 1 – Get Payment Instrument Details
  Future<List<PaymentInstrument>> getInstruments() async {
    final payload = {
      'MerchantId': PaymentConfig.merchantId,
      'MerchantName': PaymentConfig.merchantName,
    };
    final sig = SignatureGenerator.generate(
        payload: payload, secretKey: PaymentConfig.secretKey);

    final json =
        await _post(PaymentConfig.instrumentsUrl, {...payload, 'Signature': sig});

    final res = NpsApiResponse<List<PaymentInstrument>>.fromJson(
      json,
      (raw) => (raw as List)
          .map((e) => PaymentInstrument.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (!res.isSuccess) throw PaymentException(res.message, res.errors);
    return res.data ?? [];
  }

  // Step 2 – Get Service Charge
  Future<ServiceCharge> getServiceCharge({
    required String amount,
    required String instrumentCode,
  }) async {
    final payload = {
      'Amount': amount,
      'InstrumentCode': instrumentCode,
      'MerchantId': PaymentConfig.merchantId,
      'MerchantName': PaymentConfig.merchantName,
    };
    final sig = SignatureGenerator.generate(
        payload: payload, secretKey: PaymentConfig.secretKey);

    final json = await _post(
        PaymentConfig.serviceChargeUrl, {...payload, 'Signature': sig});

    final res = NpsApiResponse<ServiceCharge>.fromJson(
      json,
      (raw) => ServiceCharge.fromJson(raw as Map<String, dynamic>),
    );

    if (!res.isSuccess) throw PaymentException(res.message, res.errors);
    return res.data!;
  }

  // Step 3 – Get Process ID
  Future<String> getProcessId({
    required String amount,
    required String merchantTxnId,
  }) async {
    final payload = {
      'Amount': amount,
      'MerchantId': PaymentConfig.merchantId,
      'MerchantName': PaymentConfig.merchantName,
      'MerchantTxnId': merchantTxnId,
    };
    final sig = SignatureGenerator.generate(
        payload: payload, secretKey: PaymentConfig.secretKey);

    final json = await _post(
        PaymentConfig.processIdUrl, {...payload, 'Signature': sig});

    final res = NpsApiResponse<ProcessIdResult>.fromJson(
      json,
      (raw) => ProcessIdResult.fromJson(raw as Map<String, dynamic>),
    );

    if (!res.isSuccess) throw PaymentException(res.message, res.errors);
    return res.data!.processId;
  }

  // Step 4 – Build self-submitting HTML form for WebView
  String buildGatewayHtml({
    required String amount,
    required String merchantTxnId,
    required String processId,
    String instrumentCode = '',
    String transactionRemarks = '',
    String responseUrl = '',
  }) {
    final sigPayload = <String, String>{
      'Amount': amount,
      'InstrumentCode': instrumentCode,
      'MerchantId': PaymentConfig.merchantId,
      'MerchantName': PaymentConfig.merchantName,
      'MerchantTxnId': merchantTxnId,
      'ProcessId': processId,
    };
    if (transactionRemarks.isNotEmpty) {
      sigPayload['TransactionRemarks'] = transactionRemarks;
    }
    final sig = SignatureGenerator.generate(
        payload: sigPayload, secretKey: PaymentConfig.secretKey);

    return '''<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>Connecting…</title>
  <style>
    *{margin:0;padding:0;box-sizing:border-box}
    body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
         background:#0A1F42;display:flex;flex-direction:column;
         align-items:center;justify-content:center;min-height:100vh;
         color:#fff;gap:16px}
    .spinner{width:44px;height:44px;border:3px solid rgba(255,255,255,.2);
             border-top-color:#fff;border-radius:50%;
             animation:spin .8s linear infinite}
    @keyframes spin{to{transform:rotate(360deg)}}
    p{font-size:14px;opacity:.7;letter-spacing:.2px}
  </style>
</head>
<body onload="document.getElementById('f').submit()">
  <div class="spinner"></div>
  <p>Connecting to secure payment gateway…</p>
  <form method="POST" action="${PaymentConfig.gatewayIndexUrl}" id="f">
    <input type="hidden" name="MerchantId"         value="${PaymentConfig.merchantId}"/>
    <input type="hidden" name="MerchantName"        value="${PaymentConfig.merchantName}"/>
    <input type="hidden" name="Amount"              value="$amount"/>
    <input type="hidden" name="MerchantTxnId"       value="$merchantTxnId"/>
    <input type="hidden" name="ProcessId"           value="$processId"/>
    <input type="hidden" name="InstrumentCode"      value="$instrumentCode"/>
    <input type="hidden" name="TransactionRemarks"  value="$transactionRemarks"/>
    <input type="hidden" name="Signature"           value="$sig"/>
    ${responseUrl.isNotEmpty ? '<input type="hidden" name="ResponseUrl" value="$responseUrl"/>' : ''}
  </form>
</body>
</html>''';
  }

  // Step 5 – Check Transaction Status
  Future<TransactionDetail> checkTransactionStatus({
    required String merchantTxnId,
  }) async {
    final payload = {
      'MerchantId': PaymentConfig.merchantId,
      'MerchantName': PaymentConfig.merchantName,
      'MerchantTxnId': merchantTxnId,
    };
    final sig = SignatureGenerator.generate(
        payload: payload, secretKey: PaymentConfig.secretKey);

    final json = await _post(
        PaymentConfig.checkStatusUrl, {...payload, 'Signature': sig});

    final res = NpsApiResponse<TransactionDetail>.fromJson(
      json,
      (raw) => TransactionDetail.fromJson(raw as Map<String, dynamic>),
    );

    if (!res.isSuccess) throw PaymentException(res.message, res.errors);
    return res.data!;
  }

  void dispose() => _dio.close();
}
