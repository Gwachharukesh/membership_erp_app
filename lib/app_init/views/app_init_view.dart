import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:membership_erp_app/app_init/view_model/app_init_event.dart';
import 'package:membership_erp_app/auth/enums/user_type_enum.dart';
import 'package:membership_erp_app/common/constants/shared_pref_initialization.dart';
import 'package:membership_erp_app/features/onboarding/views/onboarding_view.dart';

import '../../auth/views/signin_view.dart';
import '../view_model/app_init_bloc.dart';
import '../view_model/app_init_state.dart';

class AppInit extends StatelessWidget {
  static const routeName = '/';
  const AppInit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppInitBloc(sharedPreferencesService: SharedPreferencesService())
            ..add(AppInitInitialized()),
      child: const AppInitView(),
    );
  }
}

class AppInitView extends StatelessWidget {
  const AppInitView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlocListener<AppInitBloc, AppInitState>(
          listener: (context, state) {
            if (state.status == AppInitStatus.navigateToOnboarding) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                OnboardingView.routeName,
                (route) => false,
              );
            } else if (state.status == AppInitStatus.navigateToLogin) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Signin.routeName,
                (route) => false,
              );
            }
            // else if(state.status == AppInitStatus.navigateToSetup){
            // }
            else if (state.status == AppInitStatus.success &&
                state.userType != null) {
              Navigator.pushReplacementNamed(
                context,
                // state.userType!.getRoute().name,
                state.userType!.getRoute(),
                arguments: state.userType!.getArgument(),
              );
            } else if (state.status == AppInitStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
              Navigator.pushNamedAndRemoveUntil(
                context,
                Signin.routeName,
                (route) => false,
              );
            }
          },
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
