import 'package:flutter/material.dart';

import '../../../common/constants/sizzed_box_constants.dart';
import '../models/notification_model.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.theme,
    required this.notification,
  });

  final ThemeData theme;
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Badge(
            isLabelVisible:
                !(notification.isRead), // show badge only if not read
            smallSize: 10,
            backgroundColor: Colors.red,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: theme.colorScheme.surfaceTint.withValues(alpha: .4),
              ),
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
          ),
          SizedBoxConstants.w10,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    // color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBoxConstants.h2,
                Text(
                  notification.description,
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBoxConstants.h2,
                Text(
                  "${notification.dayAgo} days ago",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
