import 'package:bloc/bloc.dart';

import '../../repository/notifiaction_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repo;
  NotificationBloc(this._repo) : super(NotificationInitial()) {
    on<FetchNotification>((event, emit) {
      emit(FetchingNotification());
      final response = _repo.fetchNotifications();
      response.match(
        (error) => ErrorFetchingNotification(error),
        (notifications) => emit(NotificationFetchedSuccessfully(notifications)),
      );
    });
  }
}
