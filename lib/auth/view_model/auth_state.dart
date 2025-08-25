import 'package:equatable/equatable.dart';

import '../enums/user_type_enum.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  failed,
  expired,
  wrongCredential,
  serverError,
}

class AuthState extends Equatable {
  const AuthState({
    this.authState = AuthStatus.initial,
    this.username = '',
    this.password = '',
    this.dbCode = '',
    this.userType = UserType.systemuser,
    this.message = '',
    this.rememberMe = true,
    this.agreePolicy = true,
  });
  final String username;
  final String password;
  final String dbCode;
  final String? message;
  final bool? rememberMe;
  final UserType userType;
  final AuthStatus authState;
  final bool agreePolicy;

  AuthState copyWith({
    String? userName,
    String? password,
    String? dbCode,
    AuthStatus? authState,
    UserType? userType,
    String? message,
    bool? rememberMe,
    bool? agreePolicy,
  }) {
    return AuthState(
      username: userName ?? this.username,
      password: password ?? this.password,
      dbCode: dbCode ?? this.dbCode,
      authState: authState ?? this.authState,
      userType: userType ?? this.userType,
      message: message ?? this.message,
      rememberMe: rememberMe ?? this.rememberMe,
      agreePolicy: agreePolicy ?? this.agreePolicy,
    );
  }

  @override
  List<Object> get props => [
    username,
    password,
    authState,
    dbCode,
    userType,
    agreePolicy,
  ];
}
