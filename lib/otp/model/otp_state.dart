import 'package:equatable/equatable.dart';

enum OtpStatus {
  initial,
  loading,
  otpVerified,
  customerCreationSuccess,
  customerCreationFailed,
  error,
  otpExpired,
}

class OtpState extends Equatable {
  const OtpState({
    this.otp = '',
    this.timeLeft = 60,
    this.status = OtpStatus.initial,
    this.errorMessage = '',
    this.canResendOTP = false,
    this.isPinComplete = false,
  });

  final String otp;
  final int timeLeft;
  final OtpStatus status;
  final String errorMessage;
  final bool canResendOTP;
  final bool isPinComplete;

  OtpState copyWith({
    String? otp,
    int? timeLeft,
    OtpStatus? status,
    String? errorMessage,
    bool? canResendOTP,
    bool? isPinComplete,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      timeLeft: timeLeft ?? this.timeLeft,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      canResendOTP: canResendOTP ?? this.canResendOTP,
      isPinComplete: isPinComplete ?? this.isPinComplete,
    );
  }

  @override
  List<Object> get props => [
        otp,
        timeLeft,
        status,
        errorMessage,
        canResendOTP,
        isPinComplete,
      ];
}