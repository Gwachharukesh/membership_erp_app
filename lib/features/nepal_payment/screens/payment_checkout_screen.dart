import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/checkout_bloc.dart';
import '../models/payment_models.dart';
import '../services/payment_repository.dart';
import '../state/checkout_state.dart';
import '../widgets/instrument_tile.dart';
import '../widgets/payment_summary_bar.dart';
import 'gateway_webview_screen.dart';
import 'transaction_result_screen.dart';

class PaymentCheckoutScreen extends StatelessWidget {
  final String amount;
  final String merchantTxnId;
  final String transactionRemarks;

  const PaymentCheckoutScreen({
    super.key,
    required this.amount,
    required this.merchantTxnId,
    this.transactionRemarks = '',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CheckoutBloc(repository: PaymentRepository())
            ..add(const LoadInstrumentsEvent()),
      child: _PaymentCheckoutScreenContent(
        amount: amount,
        merchantTxnId: merchantTxnId,
        transactionRemarks: transactionRemarks,
      ),
    );
  }
}

class _PaymentCheckoutScreenContent extends StatelessWidget {
  final String amount;
  final String merchantTxnId;
  final String transactionRemarks;

  const _PaymentCheckoutScreenContent({
    required this.amount,
    required this.merchantTxnId,
    required this.transactionRemarks,
  });

  void _handleGatewayReady(BuildContext context, GatewayReadyPayload payload) {
    final bloc = context.read<CheckoutBloc>();
    bloc.add(const ClearGatewayReadyEvent());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GatewayWebViewScreen(
          htmlContent: payload.htmlContent,
          merchantTxnId: payload.merchantTxnId,
          bloc: bloc,
        ),
      ),
    );
  }

  void _handleTransactionResult(
    BuildContext context,
    TransactionDetail result,
  ) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TransactionResultScreen(transaction: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state.gatewayReady != null) {
          _handleGatewayReady(context, state.gatewayReady!);
        }
        if (state.transactionResult != null) {
          _handleTransactionResult(context, state.transactionResult!);
        }
        // Show error message if payment initiation fails
        if (!state.initiatingPayment &&
            state.errorMessage != null &&
            state.gatewayReady == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: const Color(0xFFDC2626),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F4F9),
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              _AmountHeader(amount: amount, txnId: merchantTxnId),
              Expanded(
                child: BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                    if (state.loadingInstruments) {
                      return const _CenteredLoader(
                        label: 'Loading payment options…',
                      );
                    }

                    if (state.instruments.isEmpty &&
                        state.errorMessage != null) {
                      return _RetryView(
                        message: state.errorMessage!,
                        onRetry: () => context.read<CheckoutBloc>().add(
                          const LoadInstrumentsEvent(),
                        ),
                      );
                    }

                    return _InstrumentList(
                      instruments: state.instruments,
                      selectedCode: state.selectedInstrument?.instrumentCode,
                      onTap: (inst) => context.read<CheckoutBloc>().add(
                        SelectInstrumentEvent(instrument: inst, amount: amount),
                      ),
                      errorMessage: state.instruments.isNotEmpty
                          ? state.errorMessage
                          : null,
                    );
                  },
                ),
              ),
              PaymentSummaryBar(
                amount: amount,
                merchantTxnId: merchantTxnId,
                transactionRemarks: transactionRemarks,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
    backgroundColor: const Color(0xFF0A1F42),
    foregroundColor: Colors.white,
    elevation: 0,
    title: const Row(
      children: [
        _SecureBadge(),
        SizedBox(width: 10),
        Text(
          'Nepal Payment',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    ),
  );
}

class _SecureBadge extends StatelessWidget {
  const _SecureBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.green.shade600,
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.lock, size: 10, color: Colors.white),
        SizedBox(width: 3),
        Text(
          'SECURE',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}

class _AmountHeader extends StatelessWidget {
  final String amount;
  final String txnId;

  const _AmountHeader({required this.amount, required this.txnId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A1F42), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amount to Pay',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'NPR $amount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Ref: $txnId',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _InstrumentList extends StatelessWidget {
  final List<PaymentInstrument> instruments;
  final String? selectedCode;
  final ValueChanged<PaymentInstrument> onTap;
  final String? errorMessage;

  const _InstrumentList({
    required this.instruments,
    required this.selectedCode,
    required this.onTap,
    this.errorMessage,
  });

  static const _typeLabels = {
    'checkoutcard': 'Card Payments',
    'ebanking': 'Internet Banking',
    'mbanking': 'Mobile Banking',
    'wallet': 'Digital Wallets',
  };

  Map<String, List<PaymentInstrument>> _grouped() {
    final Map<String, List<PaymentInstrument>> map = {};
    for (final i in instruments) {
      final key = i.bankType.isNotEmpty ? i.bankType : 'other';
      map.putIfAbsent(key, () => []).add(i);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _grouped();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      children: [
        const Text(
          'Select Payment Method',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0A1F42),
          ),
        ),
        const SizedBox(height: 12),
        ...groups.entries.map((e) {
          final label = _typeLabels[e.key.toLowerCase()] ?? e.key;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              ...e.value.map(
                (inst) => InstrumentTile(
                  instrument: inst,
                  isSelected: inst.instrumentCode == selectedCode,
                  onTap: () => onTap(inst),
                ),
              ),
              const SizedBox(height: 4),
            ],
          );
        }),
        if (errorMessage != null) _ErrorBanner(message: errorMessage!),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF1F2),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFDC2626).withValues(alpha: 0.3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class _CenteredLoader extends StatelessWidget {
  final String label;
  const _CenteredLoader({required this.label});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(color: Color(0xFF1565C0)),
        const SizedBox(height: 16),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    ),
  );
}

class _RetryView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _RetryView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1565C0),
              side: const BorderSide(color: Color(0xFF1565C0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
