import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ImageWidget({super.key, required this.imageUrl, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height * .1,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }
}
