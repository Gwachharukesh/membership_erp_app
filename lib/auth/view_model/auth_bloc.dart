import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:membership_erp_app/auth/enums/user_type_enum.dart';
import 'package:membership_erp_app/auth/repository/auth_repository.dart';

import '../../common/constants/shared_constant.dart';
import '../../common/constants/shared_pref_initialization.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  AuthBloc(this._repository) : super(AuthState()) {
    
    on<LoadData>((event, emit) {
      SharedPreferencesService shared = SharedPreferencesService();
      String? userName = shared.getString(SharedConstant.loginUserName);
      String? password = shared.getString(SharedConstant.loginPassword);
      String? dbCode = shared.getString(SharedConstant.dbCode);
      emit(
        state.copyWith(userName: userName, password: password, dbCode: dbCode),
      );
    });

    on<Signin>((event, emit) async {
      emit(state.copyWith(authState: AuthStatus.loading));
      try {
        final response = await _repository.signin(
          username: state.username,
          password: state.password,
          isForMasterToken: false,
        );

        if (response?.accessToken != null) {
          UserType userType = UserType.values.firstWhere(
            (user) =>
                user.title?.toLowerCase() == response?.userType?.toLowerCase(),
            orElse: () => UserType.member,
          );
          emit(
            state.copyWith(authState: AuthStatus.success, userType: userType),
          );
        } else {
          emit(
            state.copyWith(
              authState: AuthStatus.failed,
              message:
                  "Failed to login. Please check your credentials and Connection",
            ),
          );
        }
      } catch (e) {
        state.copyWith(authState: AuthStatus.failed, message: e.toString());
      }
    });

    on<OnRememberMeChanged>((event, emit) {
      emit(state.copyWith(rememberMe: event.status));
    });

    on<OnAgreePolicy>((event, emit) {
      emit(state.copyWith(agreePolicy: event.status));
    });

    on<OnUserNameChange>((event, emit) {
      emit(state.copyWith(userName: event.username));
    });

    on<OnPasswordChange>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
  }
}
