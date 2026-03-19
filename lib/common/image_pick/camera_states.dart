part of 'camera_bloc.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraInitializing extends CameraState {}

class CameraInitialized extends CameraState {
  final CameraController controller;
  final CameraLensDirection direction;

  const CameraInitialized(this.controller, this.direction);

  @override
  List<Object?> get props => [controller, direction];
}

class CameraError extends CameraState {
  final String message;
  final bool canRetry;

  const CameraError(this.message, {this.canRetry = true});

  @override
  List<Object?> get props => [message, canRetry];
}

class CameraPermissionDenied extends CameraState {}

class CameraCapturing extends CameraState {}

class CameraImageCaptured extends CameraState {
  final File image;

  const CameraImageCaptured(this.image);

  @override
  List<Object?> get props => [image];
}
