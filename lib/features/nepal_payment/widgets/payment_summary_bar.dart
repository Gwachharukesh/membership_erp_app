// lib/features/nepal_payment/widgets/payment_summary_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/checkout_bloc.dart';
import '../state/checkout_state.dart';

class PaymentSummaryBar extends StatelessWidget {
  final String amount;
  final String merchantTxnId;
  final String transactionRemarks;

  const PaymentSummaryBar({
    super.key,
    required this.amount,
    required this.merchantTxnId,
    required this.transactionRemarks,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        // Show error if payment initiation fails
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
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          final selected = state.selectedInstrument;
          final charge = state.serviceCharge;
          final loadingCharge = state.loadingServiceCharge;
          final initiating = state.initiatingPayment;

          final total = charge == null
              ? double.tryParse(amount) ?? 0
              : charge.totalPayable;

          final canPay = selected != null && !loadingCharge && !initiating;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Charge breakdown ────────────────────────────────────────────
                if (loadingCharge)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.8,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Calculating charge…',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else if (charge != null) ...[
                  _Row('Subtotal', 'NPR ${charge.amount}'),
                  _Row(
                    'Service Charge',
                    'NPR ${charge.totalChargeAmount.toStringAsFixed(2)}',
                    valueColor: const Color(0xFFD97706),
                  ),
                  const Divider(height: 14),
                  _Row(
                    'Total',
                    'NPR ${total.toStringAsFixed(2)}',
                    bold: true,
                    valueColor: const Color(0xFF0A1F42),
                  ),
                  const SizedBox(height: 12),
                ],

                // ── Pay button ──────────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0A1F42),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: const Color(0xFFCBD5E1),
                    ),
                    onPressed: canPay
                        ? () => context.read<CheckoutBloc>().add(
                            InitiatePaymentEvent(
                              amount: amount,
                              merchantTxnId: merchantTxnId,
                              transactionRemarks: transactionRemarks,
                            ),
                          )
                        : null,
                    child: initiating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.lock_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selected == null
                                    ? 'Select a payment method'
                                    : 'Pay NPR ${total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // ── Security note ───────────────────────────────────────────────
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 11,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Secured by Nepal Payment Solution Ltd. · PSO Licensed NRB',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _Row(this.label, this.value, {this.bold = false, this.valueColor});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 14 : 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
            color: bold ? const Color(0xFF0A1F42) : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 14 : 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color:
                valueColor ??
                (bold ? const Color(0xFF0A1F42) : Colors.grey.shade800),
          ),
        ),
      ],
    ),
  );
}
