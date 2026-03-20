import 'package:flutter/foundation.dart';
import '../models/payment_models.dart';

/// Payload emitted once a process ID has been obtained and the HTML form built.
@immutable
class GatewayReadyPayload {
  final String htmlContent;
  final String merchantTxnId;

  const GatewayReadyPayload({
    required this.htmlContent,
    required this.merchantTxnId,
  });
}

/// Represents every possible state of the checkout flow.
@immutable
class CheckoutState {
  final List<PaymentInstrument> instruments;
  final bool loadingInstruments;

  final PaymentInstrument? selectedInstrument;
  final ServiceCharge? serviceCharge;
  final bool loadingServiceCharge;

  final bool initiatingPayment;

  /// Set when the gateway HTML is ready → triggers WebView navigation.
  final GatewayReadyPayload? gatewayReady;

  final TransactionDetail? transactionResult;
  final bool loadingStatus;

  final String? errorMessage;

  const CheckoutState({
    this.instruments = const [],
    this.loadingInstruments = false,
    this.selectedInstrument,
    this.serviceCharge,
    this.loadingServiceCharge = false,
    this.initiatingPayment = false,
    this.gatewayReady,
    this.transactionResult,
    this.loadingStatus = false,
    this.errorMessage,
  });

  bool get isBusy =>
      loadingInstruments ||
      loadingServiceCharge ||
      initiatingPayment ||
      loadingStatus;

  double totalPayable(String rawAmount) {
    final base = double.tryParse(rawAmount) ?? 0;
    if (serviceCharge == null) return base;
    return base + serviceCharge!.totalChargeAmount;
  }

  CheckoutState copyWith({
    List<PaymentInstrument>? instruments,
    bool? loadingInstruments,
    PaymentInstrument? selectedInstrument,
    bool clearSelectedInstrument = false,
    ServiceCharge? serviceCharge,
    bool clearServiceCharge = false,
    bool? loadingServiceCharge,
    bool? initiatingPayment,
    GatewayReadyPayload? gatewayReady,
    bool clearGatewayReady = false,
    TransactionDetail? transactionResult,
    bool? loadingStatus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CheckoutState(
      instruments: instruments ?? this.instruments,
      loadingInstruments: loadingInstruments ?? this.loadingInstruments,
      selectedInstrument: clearSelectedInstrument
          ? null
          : selectedInstrument ?? this.selectedInstrument,
      serviceCharge:
          clearServiceCharge ? null : serviceCharge ?? this.serviceCharge,
      loadingServiceCharge:
          loadingServiceCharge ?? this.loadingServiceCharge,
      initiatingPayment: initiatingPayment ?? this.initiatingPayment,
      gatewayReady:
          clearGatewayReady ? null : gatewayReady ?? this.gatewayReady,
      transactionResult: transactionResult ?? this.transactionResult,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
