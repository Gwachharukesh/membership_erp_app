import 'package:fpdart/fpdart.dart';
import 'package:membership_erp_app/features/notification/models/notification_model.dart';

abstract class NotificationRepository {
  Either<String, List<NotificationModel>> fetchNotifications();
  // Future<void> markAsRead(String title);
}

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Either<String, List<NotificationModel>> fetchNotifications() {
    List<NotificationModel> notifications = [];
    for (int i = 0; i < dummyNotifications.length; i++) {
      notifications.add(NotificationModel.fromJson(dummyNotifications[i]));
    }
    return Right(notifications);
  }
}
