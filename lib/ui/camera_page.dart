import 'package:camera/camera.dart';
import 'package:craft_dots/ui/preview_screen.dart';
import 'package:craft_dots/ui/spinner.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  bool _isCameraInitialized = false;
  int selectedDirection = 0;
  String imagePath = "";

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    onNewCameraSelected(cameras[selectedDirection]);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Take a picture."),
          backgroundColor: Colors.green,
        ),
        body: _isCameraInitialized
            ? Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1 / controller!.value.aspectRatio,
                      child: controller!.buildPreview(),
                    ),
                  ),
                  controlRow(context),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Spinner(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget controlRow(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                if (selectedDirection == 0) {
                  selectedDirection++;
                } else {
                  selectedDirection = 0;
                }
                _isCameraInitialized = false;
                onNewCameraSelected(cameras[selectedDirection]);
                setState(() {});
              },
              icon: Icon(
                  _getCameraLensIcon(cameras[selectedDirection].lensDirection)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: captureButton(context),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () {
                // TODO Add filter to preview screen here
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget captureButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: const SizedBox(height: 25, width: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
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

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.photo_camera_back;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
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
