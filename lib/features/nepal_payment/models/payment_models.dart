// lib/features/payment/models/payment_models.dart

import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Generic API envelope
// ─────────────────────────────────────────────────────────────────────────────

@immutable
class NpsApiResponse<T> {
  final String code; // "0" = success, "1" = error
  final String message;
  final List<NpsApiError> errors;
  final T? data;

  const NpsApiResponse({
    required this.code,
    required this.message,
    required this.errors,
    this.data,
  });

  bool get isSuccess => code == '0';

  factory NpsApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic raw)? parser,
  ) {
    return NpsApiResponse<T>(
      code: json['code']?.toString() ?? '1',
      message: json['message']?.toString() ?? '',
      errors: (json['errors'] as List<dynamic>? ?? [])
          .map((e) => NpsApiError.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: (parser != null && json['data'] != null)
          ? parser(json['data'])
          : null,
    );
  }
}

@immutable
class NpsApiError {
  final String code;
  final String message;

  const NpsApiError({required this.code, required this.message});

  factory NpsApiError.fromJson(Map<String, dynamic> json) => NpsApiError(
        code: json['error_code']?.toString() ?? '',
        message: json['error_message']?.toString() ?? '',
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// 1.5.1 – Payment Instrument
// ─────────────────────────────────────────────────────────────────────────────

@immutable
class PaymentInstrument {
  final String institutionName;
  final String instrumentName;
  final String instrumentCode;
  final String? instrumentValue;
  final String logoUrl;
  final String bankUrl;
  final String bankType;

  const PaymentInstrument({
    required this.institutionName,
    required this.instrumentName,
    required this.instrumentCode,
    this.instrumentValue,
    required this.logoUrl,
    required this.bankUrl,
    required this.bankType,
  });

  factory PaymentInstrument.fromJson(Map<String, dynamic> json) =>
      PaymentInstrument(
        institutionName: json['InstitutionName']?.toString() ?? '',
        instrumentName: json['InstrumentName']?.toString() ?? '',
        instrumentCode: json['InstrumentCode']?.toString() ?? '',
        instrumentValue: json['InstrumentValue']?.toString(),
        logoUrl: json['LogoUrl']?.toString() ?? '',
        bankUrl: json['BankUrl']?.toString() ?? '',
        bankType: json['BankType']?.toString() ?? '',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentInstrument &&
          instrumentCode == other.instrumentCode;

  @override
  int get hashCode => instrumentCode.hashCode;
}

// ─────────────────────────────────────────────────────────────────────────────
// 1.5.2 – Service Charge
// ─────────────────────────────────────────────────────────────────────────────

@immutable
class ServiceCharge {
  final String amount;
  final String commissionType; // "f" = flat  |  "p" = percentage
  final String chargeValue;
  final double totalChargeAmount;

  const ServiceCharge({
    required this.amount,
    required this.commissionType,
    required this.chargeValue,
    required this.totalChargeAmount,
  });

  double get totalPayable =>
      (double.tryParse(amount) ?? 0) + totalChargeAmount;

  factory ServiceCharge.fromJson(Map<String, dynamic> json) => ServiceCharge(
        amount: json['Amount']?.toString() ?? '0',
        commissionType: json['CommissionType']?.toString() ?? '',
        chargeValue: json['ChargeValue']?.toString() ?? '0',
        totalChargeAmount:
            double.tryParse(json['TotalChargeAmount']?.toString() ?? '0') ??
                0,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// 1.5.3 – Process ID
// ─────────────────────────────────────────────────────────────────────────────

@immutable
class ProcessIdResult {
  final String processId;
  const ProcessIdResult({required this.processId});

  factory ProcessIdResult.fromJson(Map<String, dynamic> json) =>
      ProcessIdResult(processId: json['ProcessId']?.toString() ?? '');
}

// ─────────────────────────────────────────────────────────────────────────────
// 1.5.5 – Transaction Status
// ─────────────────────────────────────────────────────────────────────────────

enum TxnStatus { success, fail, pending, unknown }

@immutable
class TransactionDetail {
  final String gatewayReferenceNo;
  final String amount;
  final String serviceCharge;
  final String transactionRemarks;
  final String transactionRemarks2;
  final String transactionRemarks3;
  final String processId;
  final String transactionDate;
  final String merchantTxnId;
  final String cbsMessage;
  final TxnStatus status;
  final String institution;
  final String instrument;
  final String paymentCurrency;
  final String exchangeRate;

  const TransactionDetail({
    required this.gatewayReferenceNo,
    required this.amount,
    required this.serviceCharge,
    required this.transactionRemarks,
    required this.transactionRemarks2,
    required this.transactionRemarks3,
    required this.processId,
    required this.transactionDate,
    required this.merchantTxnId,
    required this.cbsMessage,
    required this.status,
    required this.institution,
    required this.instrument,
    required this.paymentCurrency,
    required this.exchangeRate,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    TxnStatus parseStatus(String? raw) => switch (raw?.toLowerCase()) {
          'success' => TxnStatus.success,
          'fail' => TxnStatus.fail,
          'pending' => TxnStatus.pending,
          _ => TxnStatus.unknown,
        };

    return TransactionDetail(
      gatewayReferenceNo: json['GatewayReferenceNo']?.toString() ?? '',
      amount: json['Amount']?.toString() ?? '',
      serviceCharge: json['ServiceCharge']?.toString() ?? '',
      transactionRemarks: json['TransactionRemarks']?.toString() ?? '',
      transactionRemarks2: json['TransactionRemarks2']?.toString() ?? '',
      transactionRemarks3: json['TransactionRemarks3']?.toString() ?? '',
      processId: json['ProcessId']?.toString() ?? '',
      transactionDate: json['TransactionDate']?.toString() ?? '',
      merchantTxnId: json['MerchantTxnId']?.toString() ?? '',
      cbsMessage: json['CbsMessage']?.toString() ?? '',
      status: parseStatus(json['Status']?.toString()),
      institution: json['Institution']?.toString() ?? '',
      instrument: json['Instrument']?.toString() ?? '',
      paymentCurrency: json['PaymentCurrency']?.toString() ?? 'NPR',
      exchangeRate: json['ExchangeRate']?.toString() ?? '1',
    );
  }
}
