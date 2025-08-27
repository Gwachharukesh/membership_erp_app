import 'dart:developer';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:membership_erp_app/config/dio/chuker_config/chucker_config.dart';
import 'package:membership_erp_app/features/notification/repository/notifiaction_repository.dart';
import 'package:membership_erp_app/features/notification/view_model/notification_bloc/notification_bloc.dart';
import 'package:membership_erp_app/features/order/repostitory/order_repository.dart';
import 'package:membership_erp_app/features/order/view_model/order_bloc/order_bloc.dart';

import 'common/constants/shared_pref_initialization.dart';
import 'config/routes/routes.dart';
import 'config/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    ChuckerFlutter.showOnRelease = await ChuckerEnabler.isEnabled();
    log('ChuckerFlutter.showOnRelease set');
  } catch (e) {
    log('Error setting ChuckerFlutter.showOnRelease: $e');
  }
  await SharedPreferencesService.init();
  await ThemeNotifier.loadTheme();
  try {
    runApp(const MyApp());
  } catch (e) {
    log(e.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final NotificationRepository notificationRepository =
        NotificationRepositoryImpl();
    final OrderRepository orderRepository = OrderRepositoryImpl();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationBloc(notificationRepository),
        ),
        BlocProvider(create: (context) => OrderBloc(orderRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Membership App',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        initialRoute: '/',
        onGenerateRoute: RouteHelper.generateRoute,
        navigatorObservers: kReleaseMode
            ? []
            : [ChuckerFlutter.navigatorObserver],
        builder: (context, child) {
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeNotifier.themeModeNotifier,
            builder: (context, themeMode, _) {
              return AnimatedTheme(
                data: themeMode == ThemeMode.dark
                    ? AppThemes.darkTheme
                    : AppThemes.lightTheme,
                duration: const Duration(milliseconds: 0),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
