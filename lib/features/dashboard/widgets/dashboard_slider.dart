import 'package:flutter/material.dart';

class BenefitSlider extends StatelessWidget {
  final ThemeData theme;

  const BenefitSlider({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> benefits = [
      {
        "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
        "title": "Exclusive Discounts",
      },
      {
        "image": "https://picsum.photos/800/600?random=1  ",
        "title": "Reward Gifts",
      },
      {
        "image": "https://picsum.photos/800/600?random=3 ",
        "title": "This is title",
      },
      {
        "image": "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
        "title": "Priority Support",
      },
    ];

    return SizedBox(
      height: 160, // fixed height for horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: benefits.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final benefit = benefits[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(benefit["image"]!, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
