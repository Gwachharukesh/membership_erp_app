class DashboardSummaryModel {

  DashboardSummaryModel({
    this.ledgerId,
    this.drPoint,
    this.crPoint,
    this.balPoint,
    this.lastInvoiceNo,
    this.lastInvoiceAmt,
    this.lastInvoiceDate,
    this.lastInvoiceMiti,
    this.lastSalesBeforeDays,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      ledgerId: json['LedgerId'] as int?,
      drPoint: json['DrPoint'] as int?,
      crPoint: json['CrPoint'] as int?,
      balPoint: json['BalPoint'] as int?,
      lastInvoiceNo: json['LastInvoiceNo'] as String?,
      lastInvoiceAmt: json['LastInvoiceAmt'] as int?,
      lastInvoiceDate: json['LastInvoiceDate'] as String?,
      lastInvoiceMiti: json['LastInvoiceMiti'] as String,
      lastSalesBeforeDays: json['LastSalesBeforeDays'] as int?,
    );
  }
  int? ledgerId;
  int? drPoint;
  int? crPoint;
  int? balPoint;
  String? lastInvoiceNo;
  int? lastInvoiceAmt;
  String? lastInvoiceDate;
  String? lastInvoiceMiti;
  int? lastSalesBeforeDays;

  Map<String, dynamic> toJson() => {
        'LedgerId': ledgerId,
        'DrPoint': drPoint,
        'CrPoint': crPoint,
        'BalPoint': balPoint,
        'LastInvoiceNo': lastInvoiceNo,
        'LastInvoiceAmt': lastInvoiceAmt,
        'LastInvoiceDate': lastInvoiceDate,
        'LastInvoiceMiti': lastInvoiceMiti,
        'LastSalesBeforeDays': lastSalesBeforeDays,
      };

  DashboardSummaryModel copyWith({
    int? ledgerId,
    int? drPoint,
    int? crPoint,
    int? balPoint,
    dynamic lastInvoiceNo,
    int? lastInvoiceAmt,
    String? lastInvoiceDate,
    String? lastInvoiceMiti,
    int? lastSalesBeforeDays,
  }) {
    return DashboardSummaryModel(
      ledgerId: ledgerId ?? this.ledgerId,
      drPoint: drPoint ?? this.drPoint,
      crPoint: crPoint ?? this.crPoint,
      balPoint: balPoint ?? this.balPoint,
      lastInvoiceNo: lastInvoiceNo ?? this.lastInvoiceNo,
      lastInvoiceAmt: lastInvoiceAmt ?? this.lastInvoiceAmt,
      lastInvoiceDate: lastInvoiceDate ?? this.lastInvoiceDate,
      lastInvoiceMiti: lastInvoiceMiti ?? this.lastInvoiceMiti,
      lastSalesBeforeDays: lastSalesBeforeDays ?? this.lastSalesBeforeDays,
    );
  }
}
