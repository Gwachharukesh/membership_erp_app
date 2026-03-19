part of 'image_picker_bloc.dart';

abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object?> get props => [];
}

class CheckPermissions extends ImagePickerEvent {
  const CheckPermissions();
}

class PickFromCamera extends ImagePickerEvent {
  const PickFromCamera();
}

class PickFromGallery extends ImagePickerEvent {
  const PickFromGallery();
}

class PickFromFile extends ImagePickerEvent {
  const PickFromFile();
}

class RemoveImage extends ImagePickerEvent {
  final File image;
  const RemoveImage(this.image);

  @override
  List<Object?> get props => [image];
}

class ClearImages extends ImagePickerEvent {
  const ClearImages();
}

class SetImages extends ImagePickerEvent {
  final List<File> images;
  const SetImages(this.images);

  @override
  List<Object?> get props => [images];
}
