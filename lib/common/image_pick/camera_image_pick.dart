import 'package:bot_toast/bot_toast.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mart_erp/common/image_pick/camera_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({
    super.key,
    this.initialCameraDirection,
    this.shouldUpdateBloc,
  });

  final bool? shouldUpdateBloc;
  final CameraLensDirection? initialCameraDirection;

  @override
  CameraPreviewScreenState createState() => CameraPreviewScreenState();
}

class CameraPreviewScreenState extends State<CameraPreviewScreen>
    with WidgetsBindingObserver {
  late CameraLensDirection _cameraDirection;
  late CameraBloc _cameraBloc;

  @override
  void initState() {
    super.initState();
    _cameraDirection =
        widget.initialCameraDirection ?? CameraLensDirection.front;
    _cameraBloc = CameraBloc()..add(InitializeCamera(_cameraDirection));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraBloc>.value(
      value: _cameraBloc,
      child: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is CameraImageCaptured) {
            // Handle successful image capture
            if (widget.shouldUpdateBloc ?? false) {
              // TODO: Implement image service integration
              // For now, just return the image
            }
            Navigator.pop(context, state.image);
          } else if (state is CameraError) {
            _showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Camera Preview'),
              actions: [
                if (state is CameraInitialized)
                  FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      final hasMultipleCameras =
                          snapshot.hasData && snapshot.data!.length > 1;
                      return IconButton(
                        icon: const Icon(Icons.switch_camera),
                        onPressed: hasMultipleCameras
                            ? () => _cameraBloc.add(SwitchCamera())
                            : null,
                        tooltip: hasMultipleCameras
                            ? 'Switch Camera'
                            : 'Only one camera available',
                      );
                    },
                  ),
                if (state is CameraError && state.canRetry)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => _cameraBloc.add(RetryInitialization()),
                    tooltip: 'Retry camera initialization',
                  ),
              ],
            ),
            body: _buildBody(context, state),
            floatingActionButton: state is CameraInitialized
                ? FloatingActionButton(
                    onPressed: () => _cameraBloc.add(CaptureImage()),
                    child: const Icon(Icons.camera),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, CameraState state) {
    if (state is CameraInitializing) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing camera...'),
          ],
        ),
      );
    }

    if (state is CameraPermissionDenied) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Camera permission required',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please grant camera permission to continue',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                await openAppSettings();
              },
              icon: const Icon(Icons.settings),
              label: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }

    if (state is CameraError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Camera initialization failed',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap refresh to retry or check device settings',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<CameraBloc>().add(RetryInitialization()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is CameraInitialized) {
      return CameraPreview(state.controller);
    }

    if (state is CameraCapturing) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Capturing image...'),
          ],
        ),
      );
    }

    return const Center(child: Text('Initializing camera...'));
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    BotToast.showText(text: message, duration: const Duration(seconds: 3));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-initialize camera when app resumes
      _cameraBloc.add(InitializeCamera(_cameraDirection));
    } else if (state == AppLifecycleState.paused) {
      // Dispose camera when app is paused to free resources
      _cameraBloc.add(DisposeCamera());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraBloc.close();
    super.dispose();
  }
}
