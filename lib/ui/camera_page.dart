import 'package:camera/camera.dart';
import 'package:craft_dots/ui/preview_screen.dart';
import 'package:craft_dots/ui/spinner.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  List cameras = [];
  int selectedCameraIndex = 0;
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.isNotEmpty) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras[selectedCameraIndex]);
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print("There was an error $err");
    });
  }

  Future _initCameraController(CameraDescription camera) async {
    if (controller != null) {
      await controller!.dispose();
    }
    controller = CameraController(camera, ResolutionPreset.high);

    controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        print("Camera has error ${controller!.value.errorDescription}");
      }
    });
    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Take a picture."),
        backgroundColor: Colors.green,
      ),
      body: !controller!.value.isInitialized
          ? const Center(child: Spinner())
          : Column(
              children: [
                Expanded(child: _cameraPreviewWidget()),
                Row(
                  children: [
                    _captureControlRowWidget(context),
                    _cameraPreviewWidget(),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _cameraPreviewWidget() {
    print("Preview widget");
    if (controller == null || !controller!.value.isInitialized) {
      return Center(
          child: Column(
        children: const [
          Text("Loading",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              )),
          Spinner(),
        ],
      ));
    }
    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: CameraPreview(controller!),
    );
  }

  void _onCapturePressed(context) async {
    try {
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      await controller?.takePicture().then((XFile? file) {
        if (mounted) {
          setState(() {});
          if (file != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Picture saved to ${file.path}'),
              ),
            );
          }
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewImageScreen(imagePath: path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Widget _cameraTogglesRowWidget() {
    if (cameras.isEmpty) {
      return const Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
            onPressed: _onSwitchCamera,
            icon: Icon(_getCameraLensIcon(lensDirection)),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }

  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
                child: const Icon(Icons.camera),
                backgroundColor: Colors.blueGrey,
                onPressed: () {
                  _onCapturePressed(context);
                })
          ],
        ),
      ),
    );
  }
}
