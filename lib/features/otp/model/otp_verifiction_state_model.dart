import 'package:equatable/equatable.dart';

class OTPVerificationState extends Equatable {
  final String otp;
  final bool isPinComplete;
  final bool isLoading;
  final bool otpVerified;
  final bool customerCreationSuccess;
  final bool customerCreationFailed;
  final bool showError;
  final String errorMessage;
  final int timeLeft;
  final bool canResendOTP;

  const OTPVerificationState({
    this.otp = '',
    this.isPinComplete = false,
    this.isLoading = false,
    this.otpVerified = false,
    this.customerCreationSuccess = false,
    this.customerCreationFailed = false,
    this.showError = false,
    this.errorMessage = '',
    this.timeLeft = 60,
    this.canResendOTP = false,
  });

  factory OTPVerificationState.initial() {
    return const OTPVerificationState();
  }

  OTPVerificationState copyWith({
    String? otp,
    bool? isPinComplete,
    bool? isLoading,
    bool? otpVerified,
    bool? customerCreationSuccess,
    bool? customerCreationFailed,
    bool? showError,
    String? errorMessage,
    int? timeLeft,
    bool? canResendOTP,
  }) {
    return OTPVerificationState(
      otp: otp ?? this.otp,
      isPinComplete: isPinComplete ?? this.isPinComplete,
      isLoading: isLoading ?? this.isLoading,
      otpVerified: otpVerified ?? this.otpVerified,
      customerCreationSuccess:
          customerCreationSuccess ?? this.customerCreationSuccess,
      customerCreationFailed:
          customerCreationFailed ?? this.customerCreationFailed,
      showError: showError ?? this.showError,
      errorMessage: errorMessage ?? this.errorMessage,
      timeLeft: timeLeft ?? this.timeLeft,
      canResendOTP: canResendOTP ?? this.canResendOTP,
    );
  }

  @override
  List<Object?> get props => [
    otp,
    isPinComplete,
    isLoading,
    otpVerified,
    customerCreationSuccess,
    customerCreationFailed,
    showError,
    errorMessage,
    timeLeft,
    canResendOTP,
  ];
}
