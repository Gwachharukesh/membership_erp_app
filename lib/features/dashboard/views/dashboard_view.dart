import 'package:flutter/material.dart';
import 'package:mart_erp/common/constants/sizzed_box_constants.dart';
import 'package:mart_erp/features/dashboard/widgets/points_summary_card.dart';

import '../widgets/dashboard_category.dart';
import '../widgets/dashboard_slider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key, required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PointsSummaryCard(theme: theme, includeHeading: false),
          SizedBoxConstants.h15,
          // Membership Benefits
          CategorySection(),
          Text(
            "Membership Benefits",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBoxConstants.h10,
          BenefitSlider(theme: theme),

          SizedBoxConstants.h25,

          // Points History
          Text(
            "Recent Points History",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBoxConstants.h10,
          _pointsHistoryTile(
            "2025-08-01",
            "Purchase at Mart",
            "+200",
            theme.colorScheme.primary,
          ),
          _pointsHistoryTile(
            "2025-08-05",
            "Redeemed Voucher",
            "-100",
            theme.colorScheme.error,
          ),
          _pointsHistoryTile(
            "2025-08-10",
            "Purchase at Mart",
            "+300",
            theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // --- Reusable Points History Tile ---
  Widget _pointsHistoryTile(
    String date,
    String activity,
    String points,
    Color color,
  ) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(activity),
      subtitle: Text(date),
      trailing: Text(
        points,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
