import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

part 'image_picker_events.dart';
part 'image_picker_states.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<File> _selectedImages = [];

  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<CheckPermissions>(_onCheckPermissions);
    on<PickFromCamera>(_onPickFromCamera);
    on<PickFromGallery>(_onPickFromGallery);
    on<PickFromFile>(_onPickFromFile);
    on<RemoveImage>(_onRemoveImage);
    on<ClearImages>(_onClearImages);
  }

  @override
  Future<void> close() {
    _selectedImages.clear();
    return super.close();
  }

  Future<void> _onCheckPermissions(
    CheckPermissions event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImagePickerLoading());

    try {
      final cameraStatus = await Permission.camera.status;
      final storageStatus = await Permission.storage.status;
      final photosStatus = await Permission.photos.status;

      if (cameraStatus.isGranted &&
          (storageStatus.isGranted || photosStatus.isGranted)) {
        emit(ImagePickerPermissionGranted());
      } else {
        // Request permissions
        final cameraResult = await Permission.camera.request();
        final storageResult = await Permission.storage.request();
        final photosResult = await Permission.photos.request();

        if (cameraResult.isGranted &&
            (storageResult.isGranted || photosResult.isGranted)) {
          emit(ImagePickerPermissionGranted());
        } else {
          emit(
            const ImagePickerPermissionDenied(
              'Required permissions denied. Please enable camera and storage permissions.',
            ),
          );
        }
      }
    } catch (e) {
      emit(ImagePickerError('Failed to check permissions: $e'));
    }
  }

  Future<void> _onPickFromCamera(
    PickFromCamera event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImagePickerLoading());

    try {
      final result = await _pickImageFromCamera();
      result.fold((failure) => emit(ImagePickerError(failure.message)), (
        image,
      ) {
        _selectedImages.clear(); // Clear existing images for single image mode
        _selectedImages.add(image);
        emit(ImagePickerImagesSelected(List.from(_selectedImages)));
      });
    } catch (e) {
      emit(ImagePickerError('Failed to pick image from camera: $e'));
    }
  }

  Future<void> _onPickFromGallery(
    PickFromGallery event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImagePickerLoading());

    try {
      final result = await _pickImageFromGallery();
      result.fold((failure) => emit(ImagePickerError(failure.message)), (
        images,
      ) {
        _selectedImages.clear(); // Clear existing images for single image mode
        _selectedImages.addAll(images.take(1)); // Only take the first image
        emit(ImagePickerImagesSelected(List.from(_selectedImages)));
      });
    } catch (e) {
      emit(ImagePickerError('Failed to pick images from gallery: $e'));
    }
  }

  Future<void> _onPickFromFile(
    PickFromFile event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImagePickerLoading());

    try {
      final result = await _pickFile();
      result.fold((failure) => emit(ImagePickerError(failure.message)), (file) {
        _selectedImages.clear(); // Clear existing images for single image mode
        _selectedImages.add(file);
        emit(ImagePickerImagesSelected(List.from(_selectedImages)));
      });
    } catch (e) {
      emit(ImagePickerError('Failed to pick file: $e'));
    }
  }

  void _onRemoveImage(RemoveImage event, Emitter<ImagePickerState> emit) {
    _selectedImages.remove(event.image);
    emit(ImagePickerImagesSelected(List.from(_selectedImages)));
  }

  void _onClearImages(ClearImages event, Emitter<ImagePickerState> emit) {
    _selectedImages.clear();
    emit(ImagePickerImagesSelected(List.from(_selectedImages)));
  }

  Future<Either<Failure, File>> _pickImageFromCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return const Left(Failure('No cameras available on this device'));
      }

      // Use image picker for camera instead of custom camera screen
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return const Left(Failure('No image captured'));
      }

      if (pickedFile.path.isEmpty) {
        return const Left(Failure('Invalid image path'));
      }

      return Right(File(pickedFile.path));
    } catch (e) {
      return Left(Failure('Camera error: $e'));
    }
  }

  Future<Either<Failure, List<File>>> _pickImageFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return const Left(Failure('No image selected'));
      }

      if (pickedFile.path.isEmpty) {
        return const Left(Failure('Invalid image path'));
      }

      final file = File(pickedFile.path);
      return Right([file]); // Return as list for consistency
    } catch (e) {
      return Left(Failure('Gallery picker error: $e'));
    }
  }

  Future<Either<Failure, File>> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result == null || result.files.isEmpty) {
        return const Left(Failure('No file selected'));
      }

      final file = File(result.files.first.path!);
      return Right(file);
    } catch (e) {
      return Left(Failure('File picker error: $e'));
    }
  }

  List<File> get selectedImages => List.unmodifiable(_selectedImages);
}

class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}
