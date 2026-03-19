part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCamera extends CameraEvent {
  final CameraLensDirection direction;

  const InitializeCamera(this.direction);

  @override
  List<Object?> get props => [direction];
}

class SwitchCamera extends CameraEvent {}

class CaptureImage extends CameraEvent {}

class DisposeCamera extends CameraEvent {}

class RetryInitialization extends CameraEvent {}
