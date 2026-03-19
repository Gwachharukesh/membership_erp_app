import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

class OtpValidationRequestModel extends Equatable {

  // Constructor with hash generation logic
  OtpValidationRequestModel({
    required this.otp,
    required this.refId,
    required this.uniqueId,
    String? hashData,
  }) : hashData = hashData ??
            generateHashData(
              refKey: uniqueId,
              otp: otp,
              uniqueId: uniqueId,
            );

  /// Factory method to create instance from JSON
  factory OtpValidationRequestModel.fromJson(Map<String, dynamic> json) {
    try {
      return OtpValidationRequestModel(
        otp: json['OTP'] as String? ?? '',
        refId: json['RefId'] as String? ?? '',
        uniqueId: json['UniqueId'] as String? ?? '',
        hashData: json['HashData'] as String?,
      );
    } catch (e, st) {
      log('❌ Error in fromJson: $e\n$st');
      rethrow;
    }
  }
  final String otp;
  final String refId;
  final String uniqueId;
  final String hashData;

  /// Convert instance to JSON
  Map<String, dynamic> toJson() => {
        'OTP': otp,
        'RefId': refId,
        'HashData':
            generateHashData(refKey: refId, otp: otp, uniqueId: uniqueId),
      };

  /// CopyWith method
  OtpValidationRequestModel copyWith({
    String? otp,
    String? refId,
    String? uniqueId,
    String? hashData,
  }) {
    return OtpValidationRequestModel(
      otp: otp ?? this.otp,
      refId: refId ?? this.refId,
      uniqueId: uniqueId ?? this.uniqueId,
      hashData: hashData,
    );
  }

  /// Hash generation method using HMAC SHA512
  static String generateHashData({
    required String refKey,
    required String otp,
    required String uniqueId,
  }) {
    try {
      var input = '$otp,NewReg,$uniqueId';
      var key = utf8.encode(r'NewReg@2024$#$');
      var bytes = utf8.encode(input.trim());

      var hmacSha512 = Hmac(sha512, key);
      var digest = hmacSha512.convert(bytes);

      var result = digest.toString().toUpperCase();
      log('✅ Generated HMAC SHA512 Hash: $result');
      return result;
    } catch (e, st) {
      log('❌ Error generating hash: $e\n$st');
      return '';
    }
  }

  @override
  List<Object?> get props => [otp, refId, uniqueId, hashData];

  @override
  bool get stringify => true;
}
