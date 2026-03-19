import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class InitializeOtp extends OtpEvent {
  final String otp;

  const InitializeOtp(this.otp);

  @override
  List<Object?> get props => [otp];
}

class VerifyOtp extends OtpEvent {
  final String otp;

  const VerifyOtp(this.otp);

  @override
  List<Object?> get props => [otp];
}

class ResendOtp extends OtpEvent {}

class ResetOtp extends OtpEvent {}
