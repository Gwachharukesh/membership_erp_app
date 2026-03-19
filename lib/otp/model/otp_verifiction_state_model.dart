// otp_verification_state.dart
class OTPVerificationState {
  const OTPVerificationState({
    required this.otp,
    required this.timeLeft,
    required this.isLoading,
    required this.showError,
    required this.errorMessage,
    required this.otpVerified,
    required this.canResendOTP,
    required this.isPinComplete,
    required this.customerCreationSuccess,
    required this.customerCreationFailed,
  });

  factory OTPVerificationState.initial() {
    return const OTPVerificationState(
        otp: '',
        timeLeft: 120,
        isLoading: false,
        showError: false,
        errorMessage: '',
        otpVerified: false,
        canResendOTP: false,
        isPinComplete: false,
        customerCreationFailed: false,
        customerCreationSuccess: false,);
  }
  final String otp;
  final int timeLeft;
  final bool isLoading;
  final bool showError;
  final String errorMessage;
  final bool otpVerified;
  final bool canResendOTP;
  final bool isPinComplete;
  final bool customerCreationSuccess;
  final bool customerCreationFailed;

  OTPVerificationState copyWith(
      {String? otp,
      int? timeLeft,
      bool? isLoading,
      bool? showError,
      String? errorMessage,
      bool? otpVerified,
      bool? canResendOTP,
      bool? isPinComplete,
      bool? customerCreationSuccess,
      bool? customerCreationFailed,}) {
    return OTPVerificationState(
        otp: otp ?? this.otp,
        timeLeft: timeLeft ?? this.timeLeft,
        isLoading: isLoading ?? this.isLoading,
        showError: showError ?? this.showError,
        errorMessage: errorMessage ?? this.errorMessage,
        otpVerified: otpVerified ?? this.otpVerified,
        canResendOTP: canResendOTP ?? this.canResendOTP,
        isPinComplete: isPinComplete ?? this.isPinComplete,
        customerCreationFailed:
            customerCreationFailed ?? this.customerCreationFailed,
        customerCreationSuccess:
            customerCreationSuccess ?? this.customerCreationSuccess,);
  }
}
