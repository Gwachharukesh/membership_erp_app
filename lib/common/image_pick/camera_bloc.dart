import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:permission_handler/permission_handler.dart';

part 'camera_events.dart';
part 'camera_states.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? _controller;
  CameraLensDirection _currentDirection = CameraLensDirection.back;
  int _retryCount = 0;
  static const int _maxRetries = 2;

  CameraBloc() : super(CameraInitial()) {
    on<InitializeCamera>(_onInitializeCamera);
    on<SwitchCamera>(_onSwitchCamera);
    on<CaptureImage>(_onCaptureImage);
    on<DisposeCamera>(_onDisposeCamera);
    on<RetryInitialization>(_onRetryInitialization);
  }

  Future<Either<String, CameraController>> _initializeCameraController(
    CameraLensDirection direction,
  ) async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return const Left('No cameras available on this device');
      }

      final selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == direction,
        orElse: () => cameras.first,
      );

      await _disposeController();

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset
            .medium, // Changed from low to medium for better quality
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg, // Explicitly set format
      );

      // Add timeout for initialization
      await controller.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Camera initialization timed out');
        },
      );

      return Right(controller);
    } on TimeoutException catch (e) {
      return Left('Camera initialization timeout: ${e.message}');
    } catch (e) {
      return Left('Failed to initialize camera: $e');
    }
  }

  Future<Either<String, bool>> _checkPermissions() async {
    try {
      final status = await Permission.camera.status;

      if (status.isGranted) {
        return const Right(true);
      }

      if (status.isDenied) {
        final requestStatus = await Permission.camera.request();
        if (requestStatus.isGranted) {
          return const Right(true);
        }
        if (requestStatus.isPermanentlyDenied) {
          return const Left(
            'Camera permission permanently denied. Please enable in app settings.',
          );
        }
        return const Left('Camera permission denied');
      }

      if (status.isPermanentlyDenied) {
        return const Left(
          'Camera permission permanently denied. Please enable in app settings.',
        );
      }

      // For iOS, permissions might be in limited or restricted state
      if (status.isLimited || status.isRestricted) {
        return const Left(
          'Camera access is restricted. Please check device settings.',
        );
      }

      return const Left('Unable to determine camera permission status');
    } catch (e) {
      log('Error checking camera permissions: $e');
      return Left('Error checking permissions: $e');
    }
  }

  Future<void> _onInitializeCamera(
    InitializeCamera event,
    Emitter<CameraState> emit,
  ) async {
    emit(CameraInitializing());

    final permissionResult = await _checkPermissions();
    if (permissionResult.isLeft()) {
      emit(CameraPermissionDenied());
      return;
    }

    final initResult = await _initializeCameraController(event.direction);
    initResult.fold(
      (error) {
        if (_retryCount < _maxRetries) {
          _retryCount++;
          log('Retrying camera initialization (attempt $_retryCount)');
          add(InitializeCamera(event.direction));
        } else {
          emit(CameraError(error));
        }
      },
      (controller) {
        _controller = controller;
        _currentDirection = event.direction;
        _retryCount = 0;
        emit(CameraInitialized(controller, event.direction));
      },
    );
  }

  Future<void> _onSwitchCamera(
    SwitchCamera event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final cameras = await availableCameras();
      if (cameras.length <= 1) {
        // No alternative camera available
        emit(
          const CameraError(
            'Only one camera available on this device',
            canRetry: false,
          ),
        );
        return;
      }

      final newDirection = _currentDirection == CameraLensDirection.front
          ? CameraLensDirection.back
          : CameraLensDirection.front;

      emit(CameraInitializing());

      final initResult = await _initializeCameraController(newDirection);
      initResult.fold(
        (error) => emit(CameraError('Failed to switch camera: $error')),
        (controller) {
          _controller = controller;
          _currentDirection = newDirection;
          emit(CameraInitialized(controller, newDirection));
        },
      );
    } catch (e) {
      log('Error switching camera: $e');
      emit(CameraError('Failed to switch camera: $e'));
    }
  }

  Future<void> _onCaptureImage(
    CaptureImage event,
    Emitter<CameraState> emit,
  ) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      emit(const CameraError('Camera not ready'));
      return;
    }

    // Check if camera is ready for capture
    if (_controller!.value.isTakingPicture) {
      emit(const CameraError('Camera is already capturing an image'));
      return;
    }

    emit(CameraCapturing());

    try {
      final image = await _controller!.takePicture().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Image capture timed out');
        },
      );

      final imageFile = File(image.path);

      if (!await imageFile.exists()) {
        emit(const CameraError('Failed to save captured image'));
        return;
      }

      // Verify file size (basic check for valid image)
      final fileSize = await imageFile.length();
      if (fileSize == 0) {
        emit(const CameraError('Captured image is empty'));
        return;
      }

      log(
        'Image captured successfully: ${imageFile.path}, size: $fileSize bytes',
      );

      // Small delay to ensure UI updates properly
      await Future.delayed(const Duration(milliseconds: 300));
      emit(CameraImageCaptured(imageFile));
    } on TimeoutException catch (e) {
      log('Image capture timeout: $e');
      emit(CameraError('Image capture timed out: ${e.message}'));
    } catch (e) {
      log('Error capturing image: $e');
      emit(CameraError('Failed to capture image: $e'));
    }
  }

  Future<void> _onDisposeCamera(
    DisposeCamera event,
    Emitter<CameraState> emit,
  ) async {
    await _disposeController();
    emit(CameraInitial());
  }

  Future<void> _onRetryInitialization(
    RetryInitialization event,
    Emitter<CameraState> emit,
  ) async {
    _retryCount = 0;
    add(InitializeCamera(_currentDirection));
  }

  Future<void> _disposeController() async {
    if (_controller != null) {
      try {
        if (_controller!.value.isInitialized) {
          await _controller!.dispose().timeout(
            const Duration(seconds: 2),
            onTimeout: () {
              log('Camera controller disposal timed out');
            },
          );
        }
      } catch (e) {
        log('Error disposing camera controller: $e');
      } finally {
        _controller = null;
      }
    }
  }

  @override
  Future<void> close() async {
    await _disposeController();
    return super.close();
  }
}
