import 'package:equatable/equatable.dart';

enum OtpStatus { initial, loading, success, error }

class OtpState extends Equatable {
  final OtpStatus status;
  final String? errorMessage;
  final bool isVerified;

  const OtpState({
    this.status = OtpStatus.initial,
    this.errorMessage,
    this.isVerified = false,
  });

  OtpState copyWith({
    OtpStatus? status,
    String? errorMessage,
    bool? isVerified,
  }) {
    return OtpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, isVerified];
}
