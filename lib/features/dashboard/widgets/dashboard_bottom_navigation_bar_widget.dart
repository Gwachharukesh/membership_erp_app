import 'package:flutter/material.dart';

class DashboardBottomNavigationBar extends StatelessWidget {
  const DashboardBottomNavigationBar({
    super.key,
    required ValueNotifier<int> selectedIndex,
    required this.theme,
  }) : _selectedIndex = selectedIndex;

  final ValueNotifier<int> _selectedIndex;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedIndex,
      builder: (context, value, child) {
        return BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false, // hides selected labels
          showUnselectedLabels: false, // hides unselected labels
          currentIndex: _selectedIndex.value,
          onTap: (val) {
            _selectedIndex.value = val;
          },
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: theme.primaryColor.withValues(alpha: 0.6),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.card_giftcard),
            //   label: "Voucher",
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: "My Order",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        );
      },
    );
  }
}
