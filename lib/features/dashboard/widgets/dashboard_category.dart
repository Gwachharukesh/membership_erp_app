import 'package:flutter/material.dart';
import 'package:membership_erp_app/common/constants/paddng_constants.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categories = [
      {"title": "Food", "icon": Icons.fastfood},
      {"title": "Gift Card", "icon": Icons.card_giftcard},
      {"title": "Merchandise", "icon": Icons.shopping_bag},
      {"title": "Electronics", "icon": Icons.electrical_services},
      {"title": "Delivery", "icon": Icons.local_shipping},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with "See All"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categories",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text("See All")),
          ],
        ),

        // Horizontal category list
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: PaddingConstants.h4,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final item = categories[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: PaddingConstants.a4,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.colorScheme.surfaceTint,

                      child: Icon(
                        item["icon"] as IconData,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["title"]?.toString() ?? '',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
