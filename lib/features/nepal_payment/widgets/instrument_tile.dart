// lib/features/payment/widgets/instrument_tile.dart

import 'package:flutter/material.dart';
import '../models/payment_models.dart';

class InstrumentTile extends StatelessWidget {
  final PaymentInstrument instrument;
  final bool isSelected;
  final VoidCallback onTap;

  const InstrumentTile({
    super.key,
    required this.instrument,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1565C0)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  )
                ],
        ),
        child: Row(
          children: [
            // ── Logo ────────────────────────────────────────────────────────
            _LogoBox(logoUrl: instrument.logoUrl),
            const SizedBox(width: 12),

            // ── Names ────────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instrument.instrumentName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF1565C0)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  if (instrument.institutionName !=
                      instrument.instrumentName) ...[
                    const SizedBox(height: 2),
                    Text(
                      instrument.institutionName,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500),
                    ),
                  ],
                ],
              ),
            ),

            // ── Radio indicator ──────────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: isSelected
                  ? const Icon(Icons.radio_button_checked,
                      color: Color(0xFF1565C0), size: 20,
                      key: ValueKey('on'))
                  : const Icon(Icons.radio_button_off,
                      color: Color(0xFFCBD5E1), size: 20,
                      key: ValueKey('off')),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoBox extends StatelessWidget {
  final String logoUrl;
  const _LogoBox({required this.logoUrl});

  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: logoUrl.isNotEmpty
              ? Image.network(
                  logoUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : const Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Color(0xFF94A3B8)),
                          ),
                        ),
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.account_balance_rounded,
                    size: 20,
                    color: Color(0xFF94A3B8),
                  ),
                )
              : const Icon(Icons.account_balance_rounded,
                  size: 20, color: Color(0xFF94A3B8)),
        ),
      );
}
