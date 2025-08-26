import 'package:equatable/equatable.dart';
import 'package:membership_erp_app/auth/enums/user_type_enum.dart';

enum AppInitStatus {
  initial,
  loading,
  success,
  failure,
  navigateToLogin,
  navigateToSetup,
  navigateToOnboarding,
}

class AppInitState extends Equatable {
  final AppInitStatus status;
  final dynamic error;
  final StackTrace? stackTrace;
  final bool isTokenValid;
  final UserType? userType;

  const AppInitState({
    this.status = AppInitStatus.initial,
    this.error,
    this.stackTrace,
    this.isTokenValid = false,
    this.userType,
  });

  AppInitState copyWith({
    AppInitStatus? status,
    dynamic error,
    StackTrace? stackTrace,
    bool? isTokenValid,
    UserType? userType,
  }) {
    return AppInitState(
      status: status ?? this.status,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      isTokenValid: isTokenValid ?? this.isTokenValid,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [
    status,
    error,
    stackTrace,
    isTokenValid,
    userType,
  ];
}
