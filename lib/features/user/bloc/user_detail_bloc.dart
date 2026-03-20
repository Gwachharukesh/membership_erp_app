import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/user_detail_service.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  UserDetailBloc() : super(const UserDetailState()) {
    on<FetchUserDetail>(_onFetchUserDetail);
    on<ResetUserDetailError>(_onResetError);
    on<ClearUserDetail>(_onClearUserDetail);
  }

  /// Fetch user details from the API
  Future<void> _onFetchUserDetail(
    FetchUserDetail event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(state.copyWith(status: UserDetailStatus.loading, errorMessage: null));

    try {
      final response = await UserDetailService.getUserDetail(
        userId: event.userId,
      );

      if (response.isSuccess == true && response.userData != null) {
        emit(
          state.copyWith(
            status: UserDetailStatus.success,
            userDetail: response.userData,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: UserDetailStatus.error,
            errorMessage:
                response.responseMSG ?? 'Failed to fetch user details',
            isNetworkError: response.isNetworkError ?? false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: UserDetailStatus.error,
          errorMessage: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  /// Reset error message
  Future<void> _onResetError(
    ResetUserDetailError event,
    Emitter<UserDetailState> emit,
  ) async {
    if (state.status == UserDetailStatus.error) {
      emit(
        state.copyWith(status: UserDetailStatus.initial, errorMessage: null),
      );
    }
  }

  /// Clear user detail data
  Future<void> _onClearUserDetail(
    ClearUserDetail event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(const UserDetailState());
  }
}
