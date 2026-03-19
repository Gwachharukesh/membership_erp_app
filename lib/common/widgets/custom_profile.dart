import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'full_screen_image_view.dart';

class CustomProfileIcon extends StatelessWidget {
  const CustomProfileIcon({
    required this.theme,
    required this.photoPath,
    this.size = 30,
    this.onTap,
    super.key,
  });

  final ThemeData theme;
  final double size;
  final VoidCallback? onTap;
  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImageView(photoPath),
              ),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: theme.primaryColor),
          borderRadius: BorderRadius.circular(size / 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 1.5), // Circular profile
          child: CachedNetworkImage(
            imageUrl: photoPath,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              final isDark = theme.brightness == Brightness.dark;
              return Shimmer.fromColors(
                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
                child: Container(width: size, height: size, color: theme.cardColor),
              );
            },
            errorWidget: (context, url, error) => Container(
              width: size,
              height: size,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.person,
                color: theme.colorScheme.outline,
                size: size * 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
