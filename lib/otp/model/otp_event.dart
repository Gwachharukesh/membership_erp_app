import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class UpdateOtp extends OtpEvent {
  const UpdateOtp({required this.otp});
  final String otp;

  @override
  List<Object> get props => [otp];
}

class VerifyOtp extends OtpEvent {}

class ResendOtp extends OtpEvent {}

class ResetOtpState extends OtpEvent {}