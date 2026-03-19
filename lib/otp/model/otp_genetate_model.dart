import 'package:mart_erp/features/customer/add_customer_model.dart';

class OtpGenerateModel {
  OtpGenerateModel({
    this.emailId,
    this.mobileNo,
    this.refId,
    this.hashData,
    this.uniqueId,
    this.addCustomerModel,
  });

  factory OtpGenerateModel.fromJson(Map<String, dynamic> json) {
    return OtpGenerateModel(
      emailId: json['EmailId'] as String?,
      mobileNo: json['MobileNo'] as String?,
      refId: json['RefId'] as String?,
      hashData: json['HashData'] as String?,
      uniqueId: json['UniqueId'] as String?,
    );
  }
  String? emailId;
  String? mobileNo;
  String? refId;
  String? hashData;
  String? uniqueId;
  AddCustomerModel? addCustomerModel;

  Map<String, dynamic> toJson() => {
    'EmailId': emailId,
    'MobileNo': mobileNo,
    'RefId': refId,
    'HashData': hashData,
  };

  OtpGenerateModel copyWith({
    String? emailId,
    String? mobileNo,
    String? refId,
    String? hashData,
    String? uniqueId,
    AddCustomerModel? addCustomerModel,
  }) {
    return OtpGenerateModel(
      emailId: emailId ?? this.emailId,
      mobileNo: mobileNo ?? this.mobileNo,
      refId: refId ?? this.refId,
      hashData: hashData ?? this.hashData,
      addCustomerModel: addCustomerModel ?? this.addCustomerModel,
      uniqueId: uniqueId ?? this.uniqueId,
    );
  }
}
