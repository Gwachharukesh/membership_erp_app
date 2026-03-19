class Domainrequestmodel {
  Domainrequestmodel({
    this.dbCode,
    this.customerCode,
    this.urlName,
    this.customerId,
    this.companyCode,
  });

  factory Domainrequestmodel.fromJson(Map<String, dynamic> json) =>
      Domainrequestmodel(
        dbCode: json['DBCode'] as String?,
        customerCode: json['CustomerCode'] as int?,
        urlName: json['UrlName'] as String?,
        customerId: json['CustomerId'] as int?,
      );
  String? dbCode;
  int? customerCode;
  String? urlName;
  int? customerId;
  String? companyCode;

  Map<String, dynamic> toJson() => {
    'dbCode': dbCode,
    'CustomerCode': customerCode,
    'UrlName': urlName,
    'CustomerId': customerId,
    'CompanyCode': companyCode,
  };

  Domainrequestmodel copyWith({
    String? dbCode,
    int? customerCode,
    String? urlName,
    int? customerId,
    String? companyCode,
  }) => Domainrequestmodel(
    dbCode: dbCode ?? this.dbCode,
    customerCode: customerCode ?? this.customerCode,
    urlName: urlName ?? this.urlName,
    customerId: customerId ?? this.customerId,
    companyCode: companyCode ?? this.companyCode,
  );
}
