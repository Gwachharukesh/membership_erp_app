import 'package:flutter/material.dart';

import '../../../common/constants/border_radius_constants.dart';
import '../../../common/constants/paddng_constants.dart';
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
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: PaddingConstants.a8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusConstants.br32,
                  color: theme.colorScheme.surfaceTint.withValues(alpha: .4),
                ),
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              if (!(notification.isRead))
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
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
