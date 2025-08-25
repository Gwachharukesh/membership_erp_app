import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../config/dio/dio_client.dart';
import '../error/error_handle.dart';
import 'path_provider_utils.dart';

class ImageDownloadUtils {
  ///download image from internet using a url
  static Future<String?> downloadImage({
    required String imageUrl,

    ///set [showSuccessMessage] true is need to show popup message to user when download completes
    bool showSuccessMessage = true,
  }) async {
    String dirPath = await PathProviderUtils.getDownloadPath();
    String imageName = imageUrl.split('-').last;

    String savePath = '$dirPath/$imageName';

    try {
      await dioClientWithoutVersion
          .download(imageUrl, savePath, onReceiveProgress: showDownloadProgress)
          .then((response) async {
            EasyLoading.dismiss();
            if (showSuccessMessage) {
              EasyLoading.showSuccess(
                'Image Downloaded successfully to Downloads/Pivotal/$imageName',
              );
            }
          });
      return savePath;
    } catch (e) {
      showException(e);

      //  EasyLoading.showError(err.toString(),duration: const Duration(seconds: 3),);
    }
    return null;
  }

  static void showDownloadProgress(int received, int total) {
    double progress = 0;

    if (total != -1) {
      progress = received / total;
      EasyLoading.showProgress(
        double.parse(progress.toStringAsFixed(2)),
        status: '${(progress * 100).toStringAsFixed(2)} %',
      );
    }
  }
}
