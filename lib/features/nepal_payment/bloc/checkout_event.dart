part of 'checkout_bloc.dart';

/// Base event for the checkout flow.
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

/// Emitted to load available payment instruments.
class LoadInstrumentsEvent extends CheckoutEvent {
  const LoadInstrumentsEvent();
}

/// Emitted when user selects a payment instrument.
class SelectInstrumentEvent extends CheckoutEvent {
  final PaymentInstrument instrument;
  final String amount;

  const SelectInstrumentEvent({required this.instrument, required this.amount});

  @override
  List<Object?> get props => [instrument, amount];
}

/// Emitted to initiate the payment process.
class InitiatePaymentEvent extends CheckoutEvent {
  final String amount;
  final String merchantTxnId;
  final String transactionRemarks;

  const InitiatePaymentEvent({
    required this.amount,
    required this.merchantTxnId,
    this.transactionRemarks = '',
  });

  @override
  List<Object?> get props => [amount, merchantTxnId, transactionRemarks];
}

/// Emitted when gateway redirects back with transaction result.
class OnGatewayCallbackEvent extends CheckoutEvent {
  final String merchantTxnId;

  const OnGatewayCallbackEvent({required this.merchantTxnId});

  @override
  List<Object?> get props => [merchantTxnId];
}

/// Emitted to clear the gateway ready state.
class ClearGatewayReadyEvent extends CheckoutEvent {
  const ClearGatewayReadyEvent();
}

/// Emitted to clear error messages.
class ClearErrorEvent extends CheckoutEvent {
  const ClearErrorEvent();
}

/// Emitted to reset the entire checkout flow.
class ResetCheckoutEvent extends CheckoutEvent {
  const ResetCheckoutEvent();
}
