import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../constants/end_points.dart';
import '../utils/image_download_utils.dart';

class FullScreenImageView extends StatelessWidget {
  const FullScreenImageView(
    this.imagePath, {
    this.useBaseUrl,
    super.key,
    this.showDownload = false,
  });
  final String imagePath;
  final bool? useBaseUrl;
  final bool? showDownload;

  @override
  Widget build(BuildContext context) {
    var url = Endpoints.baseUrl.replaceFirst('online/', 'online');

    var withBaseUrl = url + imagePath;
    log(withBaseUrl);
    return Stack(
      children: [
        imagePath.isNotEmpty
            ? PhotoView(
                imageProvider: useBaseUrl ?? false
                    ? NetworkImage(withBaseUrl)
                    : NetworkImage(imagePath),
              )
            : const Center(child: Icon(Icons.person)),
        showDownload ?? false
            ? Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () async => ImageDownloadUtils.downloadImage(
                    imageUrl: (useBaseUrl ?? false) ? withBaseUrl : imagePath,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 34, right: 12),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: CircleAvatar(
                        radius: 15,
                        child: Icon(Icons.download),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
