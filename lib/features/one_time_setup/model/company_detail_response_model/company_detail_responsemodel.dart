class CompanyDetailResponseModel {
  CompanyDetailResponseModel({
    this.name,
    this.address,
    this.phoneNo,
    this.faxNo,
    this.emalId,
    this.webSite,
    this.logoPath,
    this.imagePath,
    this.bannerPath,
    this.content,
    this.country,
    this.responseMsg,
    this.isSuccess,
    this.entityId,
    this.errorNumber,
    this.cUserName,
    this.expireDateTime,
  });

  factory CompanyDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      CompanyDetailResponseModel(
        name: json['Name'] as String?,
        address: json['Address'] as String?,
        phoneNo: json['PhoneNo'] as String?,
        faxNo: json['FaxNo'] as String?,
        emalId: json['EmalId'] as String?,
        webSite: json['WebSite'] as String?,
        logoPath: json['LogoPath'] as String?,
        imagePath: json['ImagePath'] as String?,
        bannerPath: json['BannerPath'] as String?,
        content: json['Content'] as String?,
        country: json['Country'] as String?,
        responseMsg: json['ResponseMSG'] as String?,
        isSuccess: json['IsSuccess'] as bool?,
        entityId: json['EntityId'] as int?,
        errorNumber: json['ErrorNumber'] as int?,
        cUserName: json['CUserName'] as dynamic,
        expireDateTime: json['ExpireDateTime'] as dynamic,
      );
  String? name;
  String? address;
  String? phoneNo;
  String? faxNo;
  String? emalId;
  String? webSite;
  String? logoPath;
  String? imagePath;
  String? bannerPath;
  String? content;
  String? country;
  String? responseMsg;
  bool? isSuccess;
  int? entityId;
  int? errorNumber;
  dynamic cUserName;
  dynamic expireDateTime;

  Map<String, dynamic> toJson() => {
    'Name': name,
    'Address': address,
    'PhoneNo': phoneNo,
    'FaxNo': faxNo,
    'EmalId': emalId,
    'WebSite': webSite,
    'LogoPath': logoPath,
    'ImagePath': imagePath,
    'BannerPath': bannerPath,
    'Content': content,
    'Country': country,
    'ResponseMSG': responseMsg,
    'IsSuccess': isSuccess,
    'EntityId': entityId,
    'ErrorNumber': errorNumber,
    'CUserName': cUserName,
    'ExpireDateTime': expireDateTime,
  };

  CompanyDetailResponseModel copyWith({
    String? name,
    String? address,
    String? phoneNo,
    String? faxNo,
    String? emalId,
    String? webSite,
    String? logoPath,
    String? imagePath,
    String? bannerPath,
    String? content,
    String? country,
    String? responseMsg,
    bool? isSuccess,
    int? entityId,
    int? errorNumber,
    dynamic cUserName,
    dynamic expireDateTime,
  }) => CompanyDetailResponseModel(
    name: name ?? this.name,
    address: address ?? this.address,
    phoneNo: phoneNo ?? this.phoneNo,
    faxNo: faxNo ?? this.faxNo,
    emalId: emalId ?? this.emalId,
    webSite: webSite ?? this.webSite,
    logoPath: logoPath ?? this.logoPath,
    imagePath: imagePath ?? this.imagePath,
    bannerPath: bannerPath ?? this.bannerPath,
    content: content ?? this.content,
    country: country ?? this.country,
    responseMsg: responseMsg ?? this.responseMsg,
    isSuccess: isSuccess ?? this.isSuccess,
    entityId: entityId ?? this.entityId,
    errorNumber: errorNumber ?? this.errorNumber,
    cUserName: cUserName ?? this.cUserName,
    expireDateTime: expireDateTime ?? this.expireDateTime,
  );
}
