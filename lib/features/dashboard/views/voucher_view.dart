import 'package:flutter/material.dart';

class VoucherView extends StatelessWidget {
  const VoucherView({super.key, required TabController voucherTabController})
    : _voucherTabController = voucherTabController;

  final TabController _voucherTabController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        TabBar(
          controller: _voucherTabController,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: theme.primaryColor,
          unselectedLabelColor: theme.disabledColor,
          tabs: const [
            Tab(text: "All Voucher"),
            Tab(text: "Used"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _voucherTabController,
            children: const [
              Center(child: Text("All Voucher Content")),
              Center(child: Text("Used Voucher Content")),
            ],
          ),
        ),
      ],
    );
  }
}
