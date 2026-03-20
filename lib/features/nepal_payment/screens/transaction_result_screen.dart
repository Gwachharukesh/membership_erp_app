import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/checkout_bloc.dart';
import '../models/payment_models.dart';

class TransactionResultScreen extends StatelessWidget {
  final TransactionDetail transaction;

  const TransactionResultScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final s = transaction.status;

    final (
      Color bg,
      Color accent,
      IconData icon,
      String title,
      String subtitle,
    ) = switch (s) {
      TxnStatus.success => (
        const Color(0xFFF0FDF4),
        const Color(0xFF16A34A),
        Icons.check_circle_rounded,
        'Payment Successful!',
        'Your payment has been processed.',
      ),
      TxnStatus.fail => (
        const Color(0xFFFFF1F2),
        const Color(0xFFDC2626),
        Icons.cancel_rounded,
        'Payment Failed',
        'Your transaction could not be completed.',
      ),
      TxnStatus.pending => (
        const Color(0xFFFFFBEB),
        const Color(0xFFD97706),
        Icons.hourglass_top_rounded,
        'Payment Pending',
        'Your transaction is being processed.',
      ),
      _ => (
        const Color(0xFFF8FAFC),
        const Color(0xFF64748B),
        Icons.help_outline_rounded,
        'Status Unknown',
        'Please contact your bank for details.',
      ),
    };

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),

              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 52, color: accent),
                ),
              ),
              const SizedBox(height: 18),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: accent,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: accent.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 28),

              _ReceiptCard(txn: transaction, accent: accent),

              const SizedBox(height: 28),

              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.read<CheckoutBloc>().add(const ResetCheckoutEvent());
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final TransactionDetail txn;
  final Color accent;

  const _ReceiptCard({required this.txn, required this.accent});

  @override
  Widget build(BuildContext context) {
    final rows = [
      if (txn.gatewayReferenceNo.isNotEmpty)
        _entry('Gateway Ref No.', txn.gatewayReferenceNo),
      if (txn.merchantTxnId.isNotEmpty)
        _entry('Merchant Txn ID', txn.merchantTxnId),
      if (txn.amount.isNotEmpty)
        _entry('Amount', '${txn.paymentCurrency} ${txn.amount}', bold: true),
      if (txn.serviceCharge.isNotEmpty && txn.serviceCharge != '0')
        _entry('Service Charge', '${txn.paymentCurrency} ${txn.serviceCharge}'),
      if (txn.institution.isNotEmpty) _entry('Institution', txn.institution),
      if (txn.instrument.isNotEmpty) _entry('Payment Method', txn.instrument),
      if (txn.transactionDate.isNotEmpty)
        _entry('Date & Time', txn.transactionDate),
      if (txn.cbsMessage.isNotEmpty) _entry('Message', txn.cbsMessage),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.receipt_long_rounded, size: 16, color: accent),
                const SizedBox(width: 8),
                Text(
                  'Transaction Receipt',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(children: rows),
          ),
        ],
      ),
    );
  }

  Widget _entry(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: bold ? const Color(0xFF0A1F42) : Colors.grey.shade700,
            ),
          ),
        ),
      ],
    ),
  );
}
