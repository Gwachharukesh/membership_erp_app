import 'package:equatable/equatable.dart';
import 'package:membership_erp_app/features/notification/models/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class FetchingNotification extends NotificationState {}

final class NotificationFetchedSuccessfully extends NotificationState {
  final List<NotificationModel> notifications;
  const NotificationFetchedSuccessfully(this.notifications);

  @override
  List<Object> get props => [notifications];
  
}

final class ErrorFetchingNotification extends NotificationState {
  final String message;
  const ErrorFetchingNotification(this.message);

  @override
  List<Object> get props => [message];
}
