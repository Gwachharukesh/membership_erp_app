import 'package:flutter/material.dart';
import 'package:mart_erp/features/notification/views/notification_view.dart';

class DashboardAppbar extends StatelessWidget {
  const DashboardAppbar({
    super.key,
    required int selectedIndex,
    required this.theme,
  }) : _selectedIndex = selectedIndex;

  final int _selectedIndex;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    switch (_selectedIndex) {
      case 0: // Dashboard / Home
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          title: Text(
            "Mart ERP",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          actions: [
            IconButton(
              icon: Badge(child: const Icon(Icons.notifications_outlined)),
              onPressed: () {
                Navigator.pushNamed(context, NotificationView.routeName);
              },
            ),
          ],
        );
      // case 1: // Voucher
      //   return AppBar(
      //     elevation: 0,
      //     title: Text("Voucher", style: theme.textTheme.titleMedium),
      //     backgroundColor: Colors.transparent,
      //     centerTitle: true,
      //     automaticallyImplyLeading: false,
      //     // actions: [
      //     //   IconButton(icon: const Icon(Icons.search), onPressed: () {}),
      //     // ],
      //   );
      case 1: // My Order
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("My Order", style: theme.textTheme.titleMedium),
        );
      case 2: // Profile
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            "My Account",
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined, size: 22),
            ),
            const SizedBox(width: 4),
          ],
        );
      default:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Dashboard"),
          automaticallyImplyLeading: false,
        );
    }
  }
}
