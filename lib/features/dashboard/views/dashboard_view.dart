import 'package:flutter/material.dart';
import 'package:membership_erp_app/common/constants/paddng_constants.dart';
import 'package:membership_erp_app/common/constants/sizzed_box_constants.dart';
import 'package:membership_erp_app/features/dashboard/widgets/points_summary_card.dart';

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

  // --- Reusable Benefit Card ---
  Widget _benefitCard(ThemeData theme, IconData icon, String title) {
    return Container(
      margin: PaddingConstants.a4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: .2),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
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
