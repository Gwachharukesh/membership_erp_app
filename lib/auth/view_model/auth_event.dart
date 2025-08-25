import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Signin extends AuthEvent {}

class OnRememberMeChanged extends AuthEvent {
  const OnRememberMeChanged({required this.status});
  final bool status;

  OnRememberMeChanged copyWith({bool? status}) {
    return OnRememberMeChanged(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}

class OnAgreePolicy extends AuthEvent {
  const OnAgreePolicy({required this.status});
  final bool status;

  OnAgreePolicy copyWith({bool? status}) {
    return OnAgreePolicy(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}

class LoadData extends AuthEvent {
  const LoadData({this.username = '', this.password = '', this.dbCode = ""});

  final String? username, password, dbCode;

  LoadData copyWith({String? username, String? password, String? dbCode}) {
    return LoadData(
      dbCode: dbCode ?? this.dbCode,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [username ?? '', password ?? '', dbCode ?? ''];
}

class OnUserNameChange extends AuthEvent {
  const OnUserNameChange({required this.username});
  final String username;

  OnUserNameChange copyWith({String? username}) {
    return OnUserNameChange(username: username ?? this.username);
  }

  @override
  List<Object> get props => [username];
}

class OnPasswordChange extends AuthEvent {
  const OnPasswordChange({required this.password});
  final String password;
  OnPasswordChange copyWith({String? password}) {
    return OnPasswordChange(password: password ?? this.password);
  }

  @override
  List<Object> get props => [password];
}

class DbCodeChange extends AuthEvent {
  const DbCodeChange({required this.dbCode});
  final String dbCode;
  DbCodeChange copyWith({String? dbCode}) {
    return DbCodeChange(dbCode: dbCode ?? this.dbCode);
  }

  @override
  List<Object> get props => [dbCode];
}
