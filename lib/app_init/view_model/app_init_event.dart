import 'package:equatable/equatable.dart';

abstract class AppInitEvent extends Equatable {
  const AppInitEvent();
  @override
  List<Object?> get props => [];
}

final class AppInitInitialized extends AppInitEvent {}

final class AppInitTokenValidated extends AppInitEvent {
  final String? tokenExpireTime;
  const AppInitTokenValidated(this.tokenExpireTime);
  @override
  List<Object?> get props => [tokenExpireTime ?? ''];
}

final class AppInitUserDetailsFetched extends AppInitEvent{}

final class AppInitNavigateToSignin extends AppInitEvent{}

final class AppInitNavigateToOnboarding extends AppInitEvent{}

final class AppInitNavigateToSetup extends AppInitEvent{}

final class AppIniterrorOccured extends AppInitEvent {
  final dynamic error;
  final StackTrace stackTrace;
  const AppIniterrorOccured(this.error, this.stackTrace);
  @override
  List<Object?> get props => [error.toString(), stackTrace.toString()];
}