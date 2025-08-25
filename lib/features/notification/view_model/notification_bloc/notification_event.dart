import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable{
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

final class FetchNotification extends NotificationEvent{}