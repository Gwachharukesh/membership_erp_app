import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

class AddCustomerModel extends Equatable {
  AddCustomerModel({
    required this.name,
    required this.mobileNo,
    required this.emailId,
    required this.panVatNo,
    required this.address,
    required this.lat,
    required this.lon,
    this.location,
    this.otp,
    this.uniqueId,
    this.image,
    this.responseMsg,
    this.imagePath,
    this.dob,
    String? tokenhashData,
    String? addCustomerhashData,
  })  : tokenhashData = tokenhashData ??
            generatetokenhashData(
                refKey: "NewReg",
                emailId: emailId ?? '',
                mobileNo: mobileNo ?? '',
                uniqueId: uniqueId ?? '',),
        addCustomerhashData = addCustomerhashData ??
            generateHashDataForCustomer(
              emailId: emailId ?? '',
              mobileNo: mobileNo ?? '',
              otp: otp ?? '',
              name: name,
              address: address ?? '',
              uniqueId: uniqueId ?? '',
            );

  /// Generate SHA256 hash
  static String generatetokenhashData({
    required String emailId,
    required String mobileNo,
    required String refKey,
    required String uniqueId,
  }) {
    try {
      // ⚠️ Make sure commas match the exact input on the website
      var input = '$emailId,$mobileNo,$refKey,$uniqueId';
      var key = utf8.encode(r'NewReg@2024$#$'); // HMAC key
      var bytes = utf8.encode(input.trim()); // Message

      // ✅ Use SHA-512 HMAC algorithm
      var hmacSha512 = Hmac(sha512, key);
      var digest = hmacSha512.convert(bytes);

      // Print result to console (upper-case hex string)
      var result = digest.toString().toUpperCase();
      log('Generated HMAC SHA512 Hash: $result');

      return result;
    } catch (e, st) {
      log('❌ Error generating hash: $e\n$st');
      return '';
    }
  }

  final String name;
  final String? mobileNo;
  final String? emailId;
  final String? panVatNo;
  final String? address;
  final String? lat;
  final String? lon;
  final String? otp;
  final String? uniqueId;
  final String? image;
  final String? responseMsg;
  final String? tokenhashData;
  final String? location;
  final String? imagePath;
  final String? addCustomerhashData;
  final String? dob;

  /// For local storage (can skip some fields)
  Map<String, dynamic> toJsonForSave() => {
        'Name': name,
        'Address': address,
        'MobileNo': mobileNo,
        'EmailId': emailId,
        'PanVatNo': panVatNo,
        'Lat': lat,
        'Lon': lon,
        'OTP': otp,
        'UniqueId': uniqueId,
        'HashData': addCustomerhashData,
        'Location': location ?? address,
        'DOB': dob,
      };

  /// For API or full export
  Map<String, dynamic> toJson() => {
        'Name': name,
        'Address': address,
        'MobileNo': mobileNo,
        'EmailId': emailId,
        'PanVatNo': panVatNo,
        'Lat': lat,
        'Lon': lon,
        'OTP': otp,
        'UniqueId': uniqueId,
        'HashData': addCustomerhashData,
        'Location': location ?? address,
        'DOB': dob,
      };

  AddCustomerModel copyWith(
      {String? name,
      String? mobileNo,
      String? emailId,
      String? panVatNo,
      String? address,
      String? lat,
      String? lon,
      String? otp,
      String? uniqueId,
      String? image,
      String? imagePath,
      String? responseMsg,
      String? tokenhashData,
      String? addCustomerhashData,
      String? dob,}) {
    return AddCustomerModel(
      name: name ?? this.name,
      mobileNo: mobileNo ?? this.mobileNo,
      emailId: emailId ?? this.emailId,
      panVatNo: panVatNo ?? this.panVatNo,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      otp: otp ?? this.otp,
      uniqueId: uniqueId ?? this.uniqueId,
      image: image ?? this.image,
      imagePath: imagePath ?? this.imagePath,
      responseMsg: responseMsg ?? this.responseMsg,
      dob: dob ?? this.dob,
      tokenhashData: tokenhashData ??
          generatetokenhashData(
              refKey: 'NewReg',
              emailId: emailId ?? this.emailId ?? '',
              mobileNo: mobileNo ?? this.mobileNo ?? '',
              uniqueId: uniqueId ?? this.uniqueId ?? '',),
      addCustomerhashData: addCustomerhashData ??
          generateHashDataForCustomer(
            emailId: emailId ?? this.emailId ?? '',
            mobileNo: mobileNo ?? this.mobileNo ?? '',
            otp: otp ?? this.otp ?? '',
            name: name ?? this.name,
            address: address ?? this.address ?? '',
            uniqueId: uniqueId ?? this.uniqueId ?? '',
          ),
    );
  }

  @override
  List<Object?> get props => [
        name,
        mobileNo,
        emailId,
      ];

  static String generateHashDataForCustomer({
    required String emailId,
    required String mobileNo,
    required String otp,
    required String name,
    required String address,
    required String uniqueId,
  }) {
    try {
      // ⚠️ Make sure commas match the exact input on the website
      var input = '$emailId,$mobileNo,$otp,$name,$address,$uniqueId';
      log('###################');
      log('Hash Input String:');
      log(input);
      log('###################');
      var key = utf8.encode(r'NewReg@2024$#$'); // HMAC key
      var bytes = utf8.encode(input.trim()); // Message

      // ✅ Use SHA-512 HMAC algorithm
      var hmacSha512 = Hmac(sha512, key);
      var digest = hmacSha512.convert(bytes);

      // Print result to console (upper-case hex string)
      var result = digest.toString().toUpperCase();
      log('Generated HMAC SHA512 Hash: $result');

      return result;
    } catch (e, st) {
      log('❌ Error generating hash: $e\n$st');
      return '';
    }
  }
}
