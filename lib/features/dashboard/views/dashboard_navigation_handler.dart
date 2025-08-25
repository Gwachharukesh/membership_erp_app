import 'package:flutter/material.dart';

import '../widgets/dashboard_appbar.dart';
import '../widgets/dashboard_bottom_navigation_bar_widget.dart';
import '../widgets/dashboard_content.dart';

class DashboardNavigationHandler extends StatefulWidget {
  static const routeName = '/DashboardNavigationHandler';
  const DashboardNavigationHandler({super.key});

  @override
  State<DashboardNavigationHandler> createState() =>
      _DashboardNavigationHandlerState();
}

class _DashboardNavigationHandlerState extends State<DashboardNavigationHandler>
    with TickerProviderStateMixin {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  late TabController _voucherTabController;

  @override
  void initState() {
    super.initState();
    _voucherTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _voucherTabController.dispose();
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder(
          valueListenable: _selectedIndex,
          builder: (context, value, child) {
            return DashboardAppbar(selectedIndex: value, theme: theme);
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, value, child) {
          return DashboardContent(
            theme: theme,
            selectedIndex: value,
            voucherTabController: _voucherTabController,
          );
        },
      ),
      bottomNavigationBar: DashboardBottomNavigationBar(
        selectedIndex: _selectedIndex,
        theme: theme,
      ),
    );
  }
}
