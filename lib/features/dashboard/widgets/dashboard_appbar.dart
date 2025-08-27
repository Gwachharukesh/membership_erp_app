import 'package:flutter/material.dart';
import 'package:membership_erp_app/common/constants/paddng_constants.dart';
import 'package:membership_erp_app/common/widgets/custom_profile.dart';
import 'package:membership_erp_app/features/notification/views/notification_view.dart';

import '../../../config/theme/app_theme.dart';
import '../../../config/theme/view_model/themeNotifier.dart';

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
      case 0: // Dashboard
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: PaddingConstants.a8,
            child: CustomProfileIcon(
              size: 60,
              theme: theme,
              photoPath:
                  'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?_gl=1*1my73ni*_ga*MTM4ODc2NDAzMS4xNzU1NDk1NTU4*_ga_8JE65Q40S6*czE3NTU2NzUyMTQkbzIkZzEkdDE3NTU2NzUyMjUkajQ5JGwwJGgw',
            ),
          ),
          title: Text("Kabita Thuyaju", style: theme.textTheme.titleMedium),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
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
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("Profile", style: theme.textTheme.titleMedium),
          actions: [
            IconButton(
              onPressed: () {
                ThemeNotifier.toggleTheme();
              },
              icon: Icon(Icons.dark_mode_rounded),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.logout_outlined)),
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
