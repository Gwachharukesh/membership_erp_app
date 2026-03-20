import 'package:equatable/equatable.dart';

import '../models/user_detail_model.dart';

enum UserDetailStatus { initial, loading, success, error, networkError }

class UserDetailState extends Equatable {
  final UserDetailStatus status;
  final UserDetailModel? userDetail;
  final String? errorMessage;
  final bool isNetworkError;

  const UserDetailState({
    this.status = UserDetailStatus.initial,
    this.userDetail,
    this.errorMessage,
    this.isNetworkError = false,
  });

  UserDetailState copyWith({
    UserDetailStatus? status,
    UserDetailModel? userDetail,
    String? errorMessage,
    bool? isNetworkError,
  }) {
    return UserDetailState(
      status: status ?? this.status,
      userDetail: userDetail ?? this.userDetail,
      errorMessage: errorMessage ?? this.errorMessage,
      isNetworkError: isNetworkError ?? this.isNetworkError,
    );
  }

  @override
  List<Object?> get props => [status, userDetail, errorMessage, isNetworkError];
}
