import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:membership_erp_app/features/notification/view_model/notification_bloc/notification_event.dart';

import '../view_model/notification_bloc/notification_bloc.dart';
import '../view_model/notification_bloc/notification_state.dart'
    show
        ErrorFetchingNotification,
        NotificationFetchedSuccessfully,
        NotificationState;
import '../widgets/notification_widget.dart';

class NotificationView extends StatefulWidget {
  static const routeName = '/notificationScreen';
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    context.read<NotificationBloc>().add(FetchNotification());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications", style: theme.textTheme.titleMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationFetchedSuccessfully) {
            if (state.notifications.isEmpty) {
              return Center(child: Text("No Nofications Found!"));
            }
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notif = state.notifications[index];
                return NotificationWidget(theme: theme, notification: notif);
              },
            );
          } else if (state is ErrorFetchingNotification) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
