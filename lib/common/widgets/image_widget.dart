import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/theme/app_colors.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ImageWidget({super.key, required this.imageUrl, this.size = 60});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height * .1,
            color: theme.cardColor,
          ),
        ),
        errorWidget: (context, url, error) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(Icons.error, color: colors.error),
        ),
      ),
    );
  }
}
