import 'package:flutter/material.dart';
import 'package:membership_erp_app/features/dashboard/views/dashboard_navigation_handler.dart';

import '../../app_init/views/app_init_view.dart';
import '../../auth/views/signin_view.dart';
import '../../auth/views/signup_view.dart';
import '../../features/notification/views/notification_view.dart';
import '../../features/onboarding/views/onboarding_view.dart';
import 'route_not_found_view.dart';

class RouteHelper {
  static const String appInit = AppInit.routeName;
  static const String onboardingView = OnboardingView.routeName;
  static const String signinView = SigninView.routeName;
  static const String signupView = SignupView.routeName;
  static const String dashboardView = DashboardNavigationHandler.routeName;
  static const String routeNotFoundView = RouteNotFoundView.routeName;
  static const String notificationView = NotificationView.routeName;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case appInit:
        return _slideTransition(const AppInit());
      case onboardingView:
        return _slideTransition(const OnboardingView());
      case signinView:
        return _slideTransition(SigninView());
      case signupView:
        return _slideTransition(SignupView());
      case dashboardView:
        return _slideTransition(DashboardNavigationHandler());
      case notificationView:
        return _slideTransition(NotificationView());
      default:
        return _slideTransition(const RouteNotFoundView());
    }
  }

  static PageRouteBuilder _slideTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
