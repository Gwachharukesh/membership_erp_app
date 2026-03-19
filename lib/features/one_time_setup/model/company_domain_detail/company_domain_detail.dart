class CompanyDomainDetail {
  CompanyDomainDetail({
    this.customerId,
    this.addressBookId,
    this.companyCode,
    this.companyTypeId,
    this.companyCategoryId,
    this.companyName,
    this.billingName,
    this.companyRegdNo,
    this.companyPanNo,
    this.companyContactNo,
    this.companyEmailId,
    this.companyStatus,
    this.countryId,
    this.branchId,
    this.agreementId,
    this.provinceState,
    this.district,
    this.localLevel,
    this.wardNo,
    this.streetName,
    this.fullAddress,
    this.logopath,
    this.photo,
    this.attachFile,
    this.panpath,
    this.taxpath,
    this.registrationpath,
    this.needToUpdate,
    this.lat,
    this.lng,
    this.domainExpiryDate,
    this.oneSignalId,
    this.oneSignalKey,
    this.smsApiPrimary,
    this.smsApiSeconday,
    this.urlName,
    this.responseMsg,
    this.isSuccess,
    this.dbName,
  });

  factory CompanyDomainDetail.fromJson(Map<String, dynamic> json) {
    try {
      return CompanyDomainDetail(
        customerId: json['CustomerId']?.toString(),
        addressBookId: json['AddressBookId']?.toString(),
        companyCode: json['CompanyCode']?.toString(),
        companyTypeId: json['CompanyTypeId']?.toString(),
        companyCategoryId: json['CompanyCategoryId']?.toString(),
        companyName: json['CompanyName']?.toString(),
        billingName: json['BillingName']?.toString(),
        companyRegdNo: json['CompanyRegdNo']?.toString(),
        companyPanNo: json['CompanyPanNo']?.toString(),
        companyContactNo: json['CompanyContactNo']?.toString(),
        companyEmailId: json['CompanyEmailId']?.toString(),
        companyStatus: json['CompanyStatus']?.toString(),
        countryId: json['CountryId']?.toString(),
        branchId: json['BranchId']?.toString(),
        agreementId: json['AgreementId']?.toString(),
        provinceState: json['ProvinceState']?.toString(),
        district: json['District']?.toString(),
        localLevel: json['LocalLevel']?.toString(),
        wardNo: json['WardNo']?.toString(),
        streetName: json['StreetName']?.toString(),
        fullAddress: json['FullAddress']?.toString(),
        logopath: json['Logopath']?.toString(),
        photo: json['Photo']?.toString(),
        attachFile: json['attachFile']?.toString(),
        panpath: json['Panpath']?.toString(),
        taxpath: json['Taxpath']?.toString(),
        registrationpath: json['Registrationpath']?.toString(),
        needToUpdate: json['NeedToUpdate'] is bool
            ? json['NeedToUpdate'] as bool?
            : null,
        lat: json['Lat']?.toString(),
        lng: json['Lng']?.toString(),
        domainExpiryDate: json['DomainExpiryDate']?.toString(),
        oneSignalId: json['OneSignalId']?.toString(),
        oneSignalKey: json['OneSignalKey']?.toString(),
        smsApiPrimary: json['SMSApiPrimary']?.toString(),
        smsApiSeconday: json['SMSApiSeconday']?.toString(),
        urlName: json['UrlName']?.toString(),
        responseMsg: json['ResponseMSG']?.toString(),
        isSuccess: json['IsSuccess'] is bool
            ? json['IsSuccess'] as bool?
            : null,
        dbName: json['DBName']?.toString(),
      );
    } catch (e) {
      return CompanyDomainDetail();
    }
  }
  String? customerId;

  String? addressBookId;

  String? companyCode;

  String? companyTypeId;

  String? companyCategoryId;

  String? companyName;

  String? billingName;

  String? companyRegdNo;

  String? companyPanNo;

  String? companyContactNo;

  String? companyEmailId;

  String? companyStatus;

  String? countryId;

  String? branchId;

  String? agreementId;

  String? provinceState;

  String? district;

  String? localLevel;

  String? wardNo;

  String? streetName;

  String? fullAddress;

  String? logopath;

  String? photo;

  String? attachFile;

  String? panpath;

  String? taxpath;

  String? registrationpath;

  bool? needToUpdate;

  String? lat;

  String? lng;

  String? domainExpiryDate;

  String? oneSignalId;

  String? oneSignalKey;

  String? smsApiPrimary;

  String? smsApiSeconday;

  String? urlName;

  String? responseMsg;

  bool? isSuccess;

  String? expireDateTime;

  String? dbName;

  Map<String, dynamic> toJson() => {
    'CustomerId': customerId,
    'AddressBookId': addressBookId,
    'CompanyCode': companyCode,
    'CompanyTypeId': companyTypeId,
    'CompanyCategoryId': companyCategoryId,
    'CompanyName': companyName,
    'BillingName': billingName,
    'CompanyRegdNo': companyRegdNo,
    'CompanyPanNo': companyPanNo,
    'CompanyContactNo': companyContactNo,
    'CompanyEmailId': companyEmailId,
    'CompanyStatus': companyStatus,
    'CountryId': countryId,
    'BranchId': branchId,
    'AgreementId': agreementId,
    'ProvinceState': provinceState,
    'District': district,
    'LocalLevel': localLevel,
    'WardNo': wardNo,
    'StreetName': streetName,
    'FullAddress': fullAddress,
    'Logopath': logopath,
    'Photo': photo,
    'attachFile': attachFile,
    'Panpath': panpath,
    'Taxpath': taxpath,
    'Registrationpath': registrationpath,
    'NeedToUpdate': needToUpdate,
    'Lat': lat,
    'Lng': lng,
    'DomainExpiryDate': domainExpiryDate,
    'OneSignalId': oneSignalId,
    'OneSignalKey': oneSignalKey,
    'SMSApiPrimary': smsApiPrimary,
    'SMSApiSeconday': smsApiSeconday,
    'UrlName': urlName,
    'ResponseMSG': responseMsg,
    'IsSuccess': isSuccess,
    'DbName': dbName ?? companyCode,
  };

  CompanyDomainDetail copyWith({
    String? customerId,
    String? addressBookId,
    String? companyCode,
    String? companyTypeId,
    String? companyCategoryId,
    String? companyName,
    String? billingName,
    String? companyRegdNo,
    String? companyPanNo,
    String? companyContactNo,
    String? companyEmailId,
    String? companyStatus,
    String? countryId,
    String? branchId,
    String? agreementId,
    String? provinceState,
    String? district,
    String? localLevel,
    String? wardNo,
    String? streetName,
    String? fullAddress,
    String? logopath,
    String? photo,
    String? attachFile,
    List<String>? attachmentColl,
    String? panpath,
    String? taxpath,
    String? registrationpath,
    bool? needToUpdate,
    String? lat,
    String? lng,
    String? domainExpiryDate,
    String? oneSignalId,
    String? oneSignalKey,
    String? smsApiPrimary,
    String? smsApiSeconday,
    String? urlName,
    String? responseMsg,
    bool? isSuccess,
    String? rId,
    String? cUserId,
    String? responseId,
    String? entityId,
    String? errorNumber,
    String? cUserName,
    String? expireDateTime,
    String? dropDownList,
    String? fieldAfter,
    String? formula,
    String? source,
    String? colWidth,
    String? dbName,
  }) => CompanyDomainDetail(
    customerId: customerId ?? this.customerId,
    addressBookId: addressBookId ?? this.addressBookId,
    companyCode: companyCode ?? this.companyCode,
    companyTypeId: companyTypeId ?? this.companyTypeId,
    companyCategoryId: companyCategoryId ?? this.companyCategoryId,
    companyName: companyName ?? this.companyName,
    billingName: billingName ?? this.billingName,
    companyRegdNo: companyRegdNo ?? this.companyRegdNo,
    companyPanNo: companyPanNo ?? this.companyPanNo,
    companyContactNo: companyContactNo ?? this.companyContactNo,
    companyEmailId: companyEmailId ?? this.companyEmailId,
    companyStatus: companyStatus ?? this.companyStatus,
    countryId: countryId ?? this.countryId,
    branchId: branchId ?? this.branchId,
    agreementId: agreementId ?? this.agreementId,
    provinceState: provinceState ?? this.provinceState,
    district: district ?? this.district,
    localLevel: localLevel ?? this.localLevel,
    wardNo: wardNo ?? this.wardNo,
    streetName: streetName ?? this.streetName,
    fullAddress: fullAddress ?? this.fullAddress,
    logopath: logopath ?? this.logopath,
    photo: photo ?? this.photo,
    attachFile: attachFile ?? this.attachFile,
    panpath: panpath ?? this.panpath,
    taxpath: taxpath ?? this.taxpath,
    registrationpath: registrationpath ?? this.registrationpath,
    needToUpdate: needToUpdate ?? this.needToUpdate,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    domainExpiryDate: domainExpiryDate ?? this.domainExpiryDate,
    oneSignalId: oneSignalId ?? this.oneSignalId,
    oneSignalKey: oneSignalKey ?? this.oneSignalKey,
    smsApiPrimary: smsApiPrimary ?? this.smsApiPrimary,
    smsApiSeconday: smsApiSeconday ?? this.smsApiSeconday,
    urlName: urlName ?? this.urlName,
    responseMsg: responseMsg ?? this.responseMsg,
    isSuccess: isSuccess ?? this.isSuccess,
    dbName: dbName ?? this.dbName,
  );
}
