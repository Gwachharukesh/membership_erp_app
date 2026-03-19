import 'package:flutter/material.dart';
import 'package:mart_erp/features/home/screen/home_screen.dart';
import 'package:mart_erp/features/order/views/my_order_view.dart';

import '../views/profile_view.dart';

class DashboardContent extends StatelessWidget {
  final int selectedIndex;
  final ThemeData theme;
  final TabController voucherTabController;

  const DashboardContent({
    super.key,
    required this.selectedIndex,
    required this.theme,
    required this.voucherTabController,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      // case 1:
      //   return VoucherView(voucherTabController: voucherTabController);
      case 1:
        return MyOrderView();
      case 2:
        return ProfileView();
      default:
        return const HomeScreen();
    }
  }
}
