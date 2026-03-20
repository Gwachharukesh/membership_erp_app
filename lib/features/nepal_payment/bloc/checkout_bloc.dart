import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/payment_models.dart';
import '../services/payment_repository.dart';
import '../state/checkout_state.dart';
import '../utils/payment_config.dart';

part 'checkout_event.dart';

/// [CheckoutBloc] drives the entire Nepal Payment checkout flow using BLoC pattern.
///
/// Every event corresponds to one user action / integration step:
///
///   [LoadInstrumentsEvent]      → Step 1 – fetch available payment instruments
///   [SelectInstrumentEvent]     → Step 2 – pick instrument + fetch service charge
///   [InitiatePaymentEvent]      → Step 3 – get process ID → build gateway HTML
///   [OnGatewayCallbackEvent]    → Step 4+5 – intercept redirect → check status
///   [ClearErrorEvent]           → utility
///   [ResetCheckoutEvent]        → restart checkout from scratch
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final PaymentRepository _repo;

  CheckoutBloc({required PaymentRepository repository})
    : _repo = repository,
      super(const CheckoutState()) {
    on<LoadInstrumentsEvent>(_onLoadInstruments);
    on<SelectInstrumentEvent>(_onSelectInstrument);
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<OnGatewayCallbackEvent>(_onGatewayCallback);
    on<ClearGatewayReadyEvent>(_onClearGatewayReady);
    on<ClearErrorEvent>(_onClearError);
    on<ResetCheckoutEvent>(_onReset);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Step 1 – Load payment instruments
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onLoadInstruments(
    LoadInstrumentsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(loadingInstruments: true, clearError: true));

    try {
      final instruments = await _repo.getInstruments();
      emit(state.copyWith(instruments: instruments, loadingInstruments: false));
    } on PaymentException catch (e) {
      emit(state.copyWith(loadingInstruments: false, errorMessage: e.message));
    } catch (e, stackTrace) {
      debugPrint('[LoadInstruments Error] $e');
      debugPrint('[StackTrace] $stackTrace');
      emit(
        state.copyWith(
          loadingInstruments: false,
          errorMessage: 'Failed to load payment methods: ${e.toString()}',
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Step 2 – Select instrument + fetch service charge
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onSelectInstrument(
    SelectInstrumentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    // Immediately reflect selection in UI
    emit(
      state.copyWith(
        selectedInstrument: event.instrument,
        clearServiceCharge: true,
        loadingServiceCharge: true,
        clearError: true,
      ),
    );

    try {
      final charge = await _repo.getServiceCharge(
        amount: event.amount,
        instrumentCode: event.instrument.instrumentCode,
      );
      emit(state.copyWith(serviceCharge: charge, loadingServiceCharge: false));
    } on PaymentException catch (e) {
      emit(
        state.copyWith(loadingServiceCharge: false, errorMessage: e.message),
      );
    } catch (e, stackTrace) {
      debugPrint('[ServiceCharge Error] $e');
      debugPrint('[StackTrace] $stackTrace');
      emit(
        state.copyWith(
          loadingServiceCharge: false,
          errorMessage: 'Failed to calculate charges: ${e.toString()}',
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Step 3 – Get Process ID → build gateway HTML
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final instrument = state.selectedInstrument;
    if (instrument == null) {
      emit(
        state.copyWith(errorMessage: 'Please select a payment method first.'),
      );
      return;
    }

    emit(
      state.copyWith(
        initiatingPayment: true,
        clearGatewayReady: true,
        clearError: true,
      ),
    );

    try {
      final processId = await _repo.getProcessId(
        amount: event.amount,
        merchantTxnId: event.merchantTxnId,
      );

      final html = _repo.buildGatewayHtml(
        amount: event.amount,
        merchantTxnId: event.merchantTxnId,
        processId: processId,
        instrumentCode: instrument.instrumentCode,
        transactionRemarks: event.transactionRemarks,
        responseUrl: PaymentConfig.responseUrlPrefix,
      );

      emit(
        state.copyWith(
          initiatingPayment: false,
          gatewayReady: GatewayReadyPayload(
            htmlContent: html,
            merchantTxnId: event.merchantTxnId,
          ),
        ),
      );
    } on PaymentException catch (e) {
      emit(state.copyWith(initiatingPayment: false, errorMessage: e.message));
    } catch (e, stackTrace) {
      debugPrint('[InitiatePayment Error] $e');
      debugPrint('[StackTrace] $stackTrace');
      emit(
        state.copyWith(
          initiatingPayment: false,
          errorMessage: 'Payment initiation failed: ${e.toString()}',
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Step 4+5 – Gateway redirected → verify transaction
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onGatewayCallback(
    OnGatewayCallbackEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: true, clearError: true));

    try {
      final detail = await _repo.checkTransactionStatus(
        merchantTxnId: event.merchantTxnId,
      );
      emit(
        state.copyWith(
          loadingStatus: false,
          transactionResult: detail,
          clearGatewayReady: true,
        ),
      );
    } on PaymentException catch (e) {
      emit(state.copyWith(loadingStatus: false, errorMessage: e.message));
    } catch (e, stackTrace) {
      debugPrint('[GatewayCallback Error] $e');
      debugPrint('[StackTrace] $stackTrace');
      emit(
        state.copyWith(
          loadingStatus: false,
          errorMessage: 'Transaction verification failed: ${e.toString()}',
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Utility events
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onClearGatewayReady(
    ClearGatewayReadyEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(clearGatewayReady: true));
  }

  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(clearError: true));
  }

  Future<void> _onReset(
    ResetCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutState());
  }

  @override
  Future<void> close() {
    _repo.dispose();
    return super.close();
  }
}
