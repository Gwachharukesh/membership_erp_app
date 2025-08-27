import 'package:bloc/bloc.dart';
import 'package:membership_erp_app/common/constants/shared_constant.dart';
import 'package:membership_erp_app/common/constants/shared_pref_initialization.dart';

import '../../auth/enums/user_type_enum.dart';
import '../../common/utils/date_time_utils.dart';
import 'app_init_event.dart';
import 'app_init_state.dart';

class AppInitBloc extends Bloc<AppInitEvent, AppInitState> {
  final SharedPreferencesService sharedPreferencesService;
  bool _hasHandledNavigation = false;
  AppInitBloc({required this.sharedPreferencesService})
    : super(const AppInitState()) {
    on<AppInitInitialized>((event, emit) async {
      if (state.status == AppInitStatus.initial) {
        emit(state.copyWith(status: AppInitStatus.loading));
        final tokenExpireTime = sharedPreferencesService
            .get(SharedConstant.expires)
            ?.toString();
        if (sharedPreferencesService.getBool(SharedConstant.showOnboarding) ??
            true) {
          add(AppInitNavigateToOnboarding());
        } else if (tokenExpireTime != null) {
          add(AppInitTokenValidated(tokenExpireTime));
        } else {
          add(AppInitNavigateToSignin());
        }
      }
    });

    on<AppInitNavigateToOnboarding>((event, emit) {
      if (!_hasHandledNavigation) {
        _hasHandledNavigation = true;
        emit(state.copyWith(status: AppInitStatus.navigateToOnboarding));
      }
    });

    on<AppInitTokenValidated>((event, emit) {
      try {
        bool isTokenValid = DateTimeUtils.isTokenExpired(
          event.tokenExpireTime!,
        );

        if (isTokenValid) {
          add(AppInitNavigateToSignin());
        } else {
          add(AppInitUserDetailsFetched());
        }
      } catch (e, s) {
        add(AppIniterrorOccured(e, s));
      }
    });

    on<AppInitUserDetailsFetched>((event, emit) {
      try {
        int? userTypeId = sharedPreferencesService.getInt(
          SharedConstant.userTypeId,
        );
        UserType userType = UserType.values.firstWhere(
          (type) => type.id == userTypeId,
        );
        emit(state.copyWith(status: AppInitStatus.success, userType: userType));
      } catch (e, stackTrace) {
        add(AppIniterrorOccured(e, stackTrace));
      }
    });

    on<AppInitNavigateToSignin>((event, emit) {
      if (!_hasHandledNavigation) {
        _hasHandledNavigation = true;
        emit(state.copyWith(status: AppInitStatus.navigateToLogin));
      }
    });

    on<AppInitNavigateToSetup>((event, emit) {
      if (!_hasHandledNavigation) {
        _hasHandledNavigation = true;
        emit(state.copyWith(status: AppInitStatus.navigateToSetup));
      }
    });

    on<AppIniterrorOccured>((event, emit) {
      sharedPreferencesService.clearAll();
      emit(
        state.copyWith(
          status: AppInitStatus.failure,
          error: event.error,
          stackTrace: event.stackTrace,
        ),
      );
    });
  }
}
