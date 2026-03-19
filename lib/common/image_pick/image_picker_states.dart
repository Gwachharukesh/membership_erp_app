part of 'image_picker_bloc.dart';

abstract class ImagePickerState extends Equatable {
  const ImagePickerState();

  @override
  List<Object?> get props => [];
}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickerLoading extends ImagePickerState {}

class ImagePickerPermissionGranted extends ImagePickerState {}

class ImagePickerPermissionDenied extends ImagePickerState {
  final String message;
  const ImagePickerPermissionDenied(this.message);

  @override
  List<Object?> get props => [message];
}

class ImagePickerImagesSelected extends ImagePickerState {
  final List<File> images;
  const ImagePickerImagesSelected(this.images);

  @override
  List<Object?> get props => [images];
}

class ImagePickerError extends ImagePickerState {
  final String message;
  const ImagePickerError(this.message);

  @override
  List<Object?> get props => [message];
}
