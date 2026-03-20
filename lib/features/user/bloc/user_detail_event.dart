import 'package:equatable/equatable.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchUserDetail extends UserDetailEvent {
  final int userId;

  const FetchUserDetail({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ResetUserDetailError extends UserDetailEvent {
  const ResetUserDetailError();
}

class ClearUserDetail extends UserDetailEvent {
  const ClearUserDetail();
}
