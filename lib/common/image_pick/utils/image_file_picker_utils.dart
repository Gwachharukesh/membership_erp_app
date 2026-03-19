// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mart_erp/common/constants/color_manager.dart';
import 'package:mart_erp/common/image_pick/image_error_builder_utils.dart';
import 'package:mart_erp/common/image_pick/image_picker_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class ImageFilePickerUtils {
  static const double maxHeight = 600;
  static const double maxWidth = 800;
  static const int quality = 15;

  static Future<bool> checkCameraPermission(BuildContext context) async {
    final cameraStatus = await Permission.camera.status;

    if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
      final status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        showSnackBar(
          context,
          'Camera permission denied permanently\nPlease enable it manually',
        );
        return false;
      }
    }
    return true;
  }

  static Future<File?> getImage({required BuildContext context}) async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } on Exception catch (e) {
      showSnackBar(context, 'Camera Exception: $e');
    }
    return null;
  }

  static Future<int?> checkImageSize(XFile pickedFile) async {
    try {
      final bytes = await pickedFile.readAsBytes();
      return bytes.length;
    } catch (e) {
      showSnackBar(null, 'Error reading file size: $e');
      return null;
    }
  }

  static Future<File?> getImageOnly({
    required BuildContext context,
    bool? shouldUpdateBloc = false,
  }) async {
    final bool permission = await checkCameraPermission(context);
    if (!permission) {
      _showSnackBar(context, 'Camera permission denied');
      return null;
    }

    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        _showSnackBar(context, 'No image captured or operation cancelled.');
        return null;
      }
    } on Exception catch (e) {
      ImageFilePickerUtils._showSnackBar(context, 'Camera Exception: $e');
      return null;
    }
  }

  static Future<Uint8List?> convertImagetoUint8List(XFile? pickedImage) async {
    try {
      if (pickedImage == null) return null;

      // Using isolate to handle the image conversion without blocking the UI
      final result = await compute(_convertImage, pickedImage.path);
      return result;
    } catch (e) {
      showSnackBar(null, 'Exception: $e');
    }
    return null;
  }

  static Future<Uint8List?> _convertImage(String path) async {
    try {
      final file = File(path);
      return await file.readAsBytes();
    } catch (e) {
      return null; // Handle errors accordingly
    }
  }

  static Future<XFile?> convertFileToXFile(File file) async {
    try {
      // Create an XFile from the File's path
      final XFile xFile = XFile(file.path);

      // Return the created XFile
      return xFile;
    } catch (e) {
      // Handle any errors that may occur
      debugPrint('Error converting File to XFile: $e');
      return null; // Return null if an error occurs
    }
  }

  static String getImageExtensionFromPath(String filePath) {
    final List<String> parts = filePath.split('.');
    if (parts.length < 2) return '';
    return parts.last;
  }

  static String getImageExtensionFromBytes(Uint8List bytes) {
    final Map<List<int>, String> magicBytes = {
      [0xFF, 0xD8]: 'jpg',
      [0x89, 0x50, 0x4E, 0x47]: 'png',
      // Add more formats as needed
    };

    for (var magicByte in magicBytes.entries) {
      if (_matchesMagicBytes(bytes, magicByte.key)) {
        return magicByte.value;
      }
    }
    return '';
  }

  static bool _matchesMagicBytes(Uint8List bytes, List<int> magicBytes) {
    if (bytes.length < magicBytes.length) return false;
    for (int i = 0; i < magicBytes.length; i++) {
      if (bytes[i] != magicBytes[i]) return false;
    }
    return true;
  }

  static Future<dynamic> openImageSheet(
    BuildContext context, {
    bool allowMulti = true,
    bool showFile = true,
    bool showGallery = true,
  }) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 170,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  context.read<ImagePickerBloc>().add(const PickFromCamera());
                  Navigator.pop(context);
                },
                leading: Icon(
                  Icons.camera_alt_rounded,
                  size: 3.h,
                  color: ColorManager.dvBlueAccent,
                ),
                title: const Text('Camera'),
              ),
              Visibility(
                visible: showGallery,
                child: ListTile(
                  onTap: () {
                    context.read<ImagePickerBloc>().add(
                      const PickFromGallery(),
                    );
                    Navigator.pop(context);
                  },
                  leading: Icon(
                    Icons.photo_library_rounded,
                    size: 3.h,
                    color: ColorManager.dvBlueAccent,
                  ),
                  title: const Text('Gallery'),
                ),
              ),
              Visibility(
                visible: showFile,
                child: ListTile(
                  onTap: () {
                    context.read<ImagePickerBloc>().add(const PickFromFile());
                    Navigator.pop(context);
                  },
                  leading: Icon(
                    Icons.attach_file_rounded,
                    size: 3.h,
                    color: ColorManager.dvBlueAccent,
                  ),
                  title: const Text('File'),
                ),
              ),
            ],
          ),
        ),
      ),
      context: context,
    );
  }

  static Widget showSelectedImage(BuildContext context) {
    return BlocBuilder<ImagePickerBloc, ImagePickerState>(
      builder: (context, state) {
        if (state is ImagePickerImagesSelected) {
          return Row(
            children: state.images
                .map(
                  (file) => Container(
                    width: 20.w,
                    height: 30.w,
                    margin: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            file,
                            errorBuilder: (context, error, stackTrace) =>
                                ImageErrorBuilderUtils.getFilePlaceHolder(),
                            width: 20.w,
                            height: 30.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned.fromRelativeRect(
                          rect: RelativeRect.fromLTRB(10.w, 0, 0, 20.w),
                          child: IconButton(
                            onPressed: () {
                              context.read<ImagePickerBloc>().add(
                                RemoveImage(file),
                              );
                            },
                            icon: Icon(Icons.close_rounded, size: 7.w),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  static void showSnackBar(BuildContext? context, String message) {
    if (context != null) {
      BotToast.showText(text: message, duration: const Duration(seconds: 3));
    }
  }

  static void _showSnackBar(BuildContext context, String message) {
    BotToast.showText(text: message, duration: const Duration(seconds: 3));
  }
}

enum FileType { pdf, image, file }

class ShowSelectedImage extends StatelessWidget {
  const ShowSelectedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerBloc, ImagePickerState>(
      builder: (context, state) {
        if (state is ImagePickerImagesSelected) {
          return Row(
            children: state.images
                .map(
                  (file) => Container(
                    width: 20.w,
                    height: 30.w,
                    margin: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            file,
                            errorBuilder: (context, error, stackTrace) =>
                                ImageErrorBuilderUtils.getFilePlaceHolder(),
                            width: 20.w,
                            height: 30.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned.fromRelativeRect(
                          rect: RelativeRect.fromLTRB(10.w, 0, 0, 20.w),
                          child: IconButton(
                            onPressed: () {
                              context.read<ImagePickerBloc>().add(
                                RemoveImage(file),
                              );
                            },
                            icon: Icon(Icons.close_rounded, size: 7.w),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  static void showSnackBar(BuildContext? context, String message) {
    if (context != null) {
      BotToast.showText(text: message, duration: const Duration(seconds: 3));
    }
  }
}
