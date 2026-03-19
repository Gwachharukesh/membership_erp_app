import 'package:dio/dio.dart';
import 'package:mart_erp/common/constants/end_points.dart';
import 'package:mart_erp/common/utils/path_provider_utils.dart';

class ImageDownloadUtils {
  ///download image from internet using a url
  static Future<String?> downloadImage({
    required String imageUrl,

    ///set [showSuccessMessage] true is need to show popup message to user when download completes
    bool showSuccessMessage = true,
  }) async {
    final String dirPath = await PathProviderUtils.getDownloadPath();
    final String imageName = imageUrl.split('-').last;

    final String savePath = '$dirPath/$imageName';

    try {
      await Dio(BaseOptions(baseUrl: Endpoints.baseUrl))
          .download(imageUrl, savePath, onReceiveProgress: showDownloadProgress)
          .then((response) async {
            if (showSuccessMessage) {
              // Scaffold mesanger ('Image downloaded to $savePath',duration: const Duration(seconds: 3),);
            }
          });
      return savePath;
    } catch (e) {
      //  EasyLoading.showError(err.toString(),duration: const Duration(seconds: 3),);
    }
    return null;
  }

  static void showDownloadProgress(int received, int total) {
    double progress = 0;

    if (total != -1) {
      progress = received / total;
    }
  }
}
