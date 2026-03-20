// lib/features/payment/utils/payment_config.dart

/// All Nepal Payment Solution (OnePG) credentials and endpoint URLs.
///
/// Replace the placeholder values with the credentials provided by NPS via email.
/// Toggle [isSandbox] to switch between sandbox and production environments.
class PaymentConfig {
  PaymentConfig._();

  // ── Credentials (provided by NPS via email) ──────────────────────────────
  static const String merchantId = '3197';
  static const String merchantName = 'dynamicapi';
  static const String secretKey = 'key@123';
  static const String authUsername = 'dynamicapi';
  static const String authPassword = 'Dynamic@123';

  // ── Environment toggle ────────────────────────────────────────────────────
  static const bool isSandbox = true;

  // ── Base URLs ─────────────────────────────────────────────────────────────
  static const String _sandboxApi = 'https://apisandbox.nepalpayment.com';
  static const String _sandboxGateway =
      'https://gatewaysandbox.nepalpayment.com';
  static const String _productionApi = 'https://api.nepalpayment.com';
  static const String _productionGateway = 'https://gateway.nepalpayment.com';

  static String get apiBase => isSandbox ? _sandboxApi : _productionApi;
  static String get gatewayBase =>
      isSandbox ? _sandboxGateway : _productionGateway;

  // ── Endpoint helpers ──────────────────────────────────────────────────────
  static String get instrumentsUrl => '$apiBase/GetPaymentInstrumentDetails';
  static String get serviceChargeUrl => '$apiBase/GetServiceCharge';
  static String get processIdUrl => '$apiBase/GetProcessId';
  static String get checkStatusUrl => '$apiBase/CheckTransactionStatus';
  static String get gatewayIndexUrl => '$gatewayBase/Payment/Index';

  // ── Your app's response / callback URL ───────────────────────────────────
  /// The WebView intercepts any navigation whose URL starts with this prefix.
  static const String responseUrlPrefix =
      'https://yourapp.com/payment/callback';
}
