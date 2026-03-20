import 'package:equatable/equatable.dart';

class UserDetailModel extends Equatable {
  final int? userId;
  final String? userName;
  final String? groupName;
  final String? name;
  final String? address;
  final String? designation;
  final String? mobileNo;
  final String? emailId;
  final String? companyName;
  final String? companyAddress;
  final String? photoPath;
  final int? userType;
  final String? branch;
  final String? responseMSG;
  final bool? isSuccess;
  final int? entityId;
  final int? errorNumber;
  final String? cUserName;
  final String? expireDateTime;
  final String? dropDownList;
  final int? fieldAfter;
  final String? formula;
  final String? source;
  final int? colWidth;
  final dynamic jsonStr;
  final String? selectOptions;
  final dynamic vId;
  final dynamic vBId;

  const UserDetailModel({
    this.userId,
    this.userName,
    this.groupName,
    this.name,
    this.address,
    this.designation,
    this.mobileNo,
    this.emailId,
    this.companyName,
    this.companyAddress,
    this.photoPath,
    this.userType,
    this.branch,
    this.responseMSG,
    this.isSuccess,
    this.entityId,
    this.errorNumber,
    this.cUserName,
    this.expireDateTime,
    this.dropDownList,
    this.fieldAfter,
    this.formula,
    this.source,
    this.colWidth,
    this.jsonStr,
    this.selectOptions,
    this.vId,
    this.vBId,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      userId: json['UserId'],
      userName: json['UserName'],
      groupName: json['GroupName'],
      name: json['Name'],
      address: json['Address'],
      designation: json['Designation'],
      mobileNo: json['MobileNo'],
      emailId: json['EmailId'],
      companyName: json['CompanyName'],
      companyAddress: json['CompanyAddress'],
      photoPath: json['PhotoPath'],
      userType: json['UserType'],
      branch: json['Branch'],
      responseMSG: json['ResponseMSG'],
      isSuccess: json['IsSuccess'],
      entityId: json['EntityId'],
      errorNumber: json['ErrorNumber'],
      cUserName: json['CUserName'],
      expireDateTime: json['ExpireDateTime'],
      dropDownList: json['DropDownList'],
      fieldAfter: json['FieldAfter'],
      formula: json['Formula'],
      source: json['Source'],
      colWidth: json['ColWidth'],
      jsonStr: json['JsonStr'],
      selectOptions: json['SelectOptions'],
      vId: json['VId'],
      vBId: json['VBId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'UserId': userId,
    'UserName': userName,
    'GroupName': groupName,
    'Name': name,
    'Address': address,
    'Designation': designation,
    'MobileNo': mobileNo,
    'EmailId': emailId,
    'CompanyName': companyName,
    'CompanyAddress': companyAddress,
    'PhotoPath': photoPath,
    'UserType': userType,
    'Branch': branch,
    'ResponseMSG': responseMSG,
    'IsSuccess': isSuccess,
    'EntityId': entityId,
    'ErrorNumber': errorNumber,
    'CUserName': cUserName,
    'ExpireDateTime': expireDateTime,
    'DropDownList': dropDownList,
    'FieldAfter': fieldAfter,
    'Formula': formula,
    'Source': source,
    'ColWidth': colWidth,
    'JsonStr': jsonStr,
    'SelectOptions': selectOptions,
    'VId': vId,
    'VBId': vBId,
  };

  UserDetailModel copyWith({
    int? userId,
    String? userName,
    String? groupName,
    String? name,
    String? address,
    String? designation,
    String? mobileNo,
    String? emailId,
    String? companyName,
    String? companyAddress,
    String? photoPath,
    int? userType,
    String? branch,
    String? responseMSG,
    bool? isSuccess,
    int? entityId,
    int? errorNumber,
    String? cUserName,
    String? expireDateTime,
    String? dropDownList,
    int? fieldAfter,
    String? formula,
    String? source,
    int? colWidth,
    dynamic jsonStr,
    String? selectOptions,
    dynamic vId,
    dynamic vBId,
  }) {
    return UserDetailModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      groupName: groupName ?? this.groupName,
      name: name ?? this.name,
      address: address ?? this.address,
      designation: designation ?? this.designation,
      mobileNo: mobileNo ?? this.mobileNo,
      emailId: emailId ?? this.emailId,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      photoPath: photoPath ?? this.photoPath,
      userType: userType ?? this.userType,
      branch: branch ?? this.branch,
      responseMSG: responseMSG ?? this.responseMSG,
      isSuccess: isSuccess ?? this.isSuccess,
      entityId: entityId ?? this.entityId,
      errorNumber: errorNumber ?? this.errorNumber,
      cUserName: cUserName ?? this.cUserName,
      expireDateTime: expireDateTime ?? this.expireDateTime,
      dropDownList: dropDownList ?? this.dropDownList,
      fieldAfter: fieldAfter ?? this.fieldAfter,
      formula: formula ?? this.formula,
      source: source ?? this.source,
      colWidth: colWidth ?? this.colWidth,
      jsonStr: jsonStr ?? this.jsonStr,
      selectOptions: selectOptions ?? this.selectOptions,
      vId: vId ?? this.vId,
      vBId: vBId ?? this.vBId,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    userName,
    groupName,
    name,
    address,
    designation,
    mobileNo,
    emailId,
    companyName,
    companyAddress,
    photoPath,
    userType,
    branch,
    responseMSG,
    isSuccess,
    entityId,
    errorNumber,
    cUserName,
    expireDateTime,
    dropDownList,
    fieldAfter,
    formula,
    source,
    colWidth,
    jsonStr,
    selectOptions,
    vId,
    vBId,
  ];
}
