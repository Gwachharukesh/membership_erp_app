import 'package:flutter/material.dart';
import 'package:mart_erp/common/constants/end_points.dart';
import 'package:mart_erp/common/utils/image_download_utils.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageView extends StatelessWidget {
  const FullScreenImageView(
    this.imagePath, {
    this.useBaseUrl,
    super.key,
    this.showDownload = false,
    this.isAssetImage = false,
  });
  final String imagePath;
  final bool? useBaseUrl;
  final bool? showDownload;
  final bool? isAssetImage;

  @override
  Widget build(BuildContext context) {
    final url = Endpoints.baseUrl.replaceFirst('online/', 'online');

    final withBaseUrl = url + imagePath;

    // Determine image provider based on type
    ImageProvider imageProvider;
    if (isAssetImage ?? false) {
      imageProvider = AssetImage(imagePath);
    } else {
      imageProvider = useBaseUrl ?? false
          ? NetworkImage(withBaseUrl)
          : NetworkImage(imagePath);
    }

    return Stack(
      children: [
        PhotoView(
          //handle failed to load image exception.
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.person)),
          imageProvider: imageProvider,
        ),
        // Only show download button for network images
        ((showDownload ?? false) && !(isAssetImage ?? false))
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
