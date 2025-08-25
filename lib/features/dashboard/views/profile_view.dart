import 'package:flutter/material.dart';
import 'package:membership_erp_app/common/constants/paddng_constants.dart';
import 'package:membership_erp_app/common/constants/sizzed_box_constants.dart';

import '../../../common/constants/border_radius_constants.dart';
import '../widgets/points_summary_card.dart';

class ProfileView extends StatelessWidget {
  // Dummy data
  final String name = "Kabita Thuyaju";
  final int totalPoints = 1500;
  final int redeemedPoints = 500;
  final int remainingPoints = 1000;

  final List<Map<String, String>> pointsHistory = [
    {"date": "2025-08-01", "activity": "Purchase", "points": "+200"},
    {"date": "2025-08-05", "activity": "Redeemed", "points": "-100"},
    {"date": "2025-08-10", "activity": "Purchase", "points": "+300"},
    {"date": "2025-08-15", "activity": "Redeemed", "points": "-200"},
  ];

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    print("Building proile");
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PointsSummaryCard(theme: theme),

          SizedBoxConstants.h25,
          // Points History
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Your Points History",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBoxConstants.h15,
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: pointsHistory.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = pointsHistory[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 20,
                    children: [
                      Container(
                        padding: PaddingConstants.a4,
                        decoration: BoxDecoration(
                          color: theme.splashColor,
                          borderRadius: BorderRadiusConstants.br8,
                          border: Border.all(
                            width: 1,
                            color: theme.secondaryHeaderColor,
                          ),
                        ),
                        child: const Icon(Icons.history),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item["activity"]!),
                          Text(item["date"]!),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    item["points"]!,
                    style: TextStyle(
                      color: item["points"]!.startsWith("+")
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
