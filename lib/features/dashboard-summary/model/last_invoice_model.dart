class LastInvoiceModel {

  LastInvoiceModel({
    this.lastInvoiceNo,
    this.lastInvoiceDate,
    this.lastInvoiceAmount,
    this.lastSalesBeforeDays,
  });

  factory LastInvoiceModel.fromJson(Map<String, dynamic> json) {
    return LastInvoiceModel(
      lastInvoiceNo: json['lastInvoiceNo'] as String?,
      lastInvoiceDate: json['lastInvoiceDate'] as String?,
      lastInvoiceAmount: json['lastInvoiceAmount'] as String?,
      lastSalesBeforeDays: json['lastSalesBeforeDays'] as String?,
    );
  }
  String? lastInvoiceNo;
  String? lastInvoiceDate;
  String? lastInvoiceAmount;
  String? lastSalesBeforeDays;

  Map<String, dynamic> toJson() {
    return {
      'lastInvoiceNo': lastInvoiceNo,
      'lastInvoiceDate': lastInvoiceDate,
      'lastInvoiceAmount': lastInvoiceAmount,
      'lastSalesBeforeDays': lastSalesBeforeDays,
    };
  }
}
