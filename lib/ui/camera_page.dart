import 'dart:io';

import 'package:camera/camera.dart';
import 'package:craft_dots/ui/spinner.dart';
import 'package:flutter/material.dart';
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
  double _minAvailableZoom = 1.0;
  final double _maxAvailableZoom = 14.0;
  double _currentZoomLevel = 1.0;

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

      cameraController
          .getMinZoomLevel()
          .then((value) => _minAvailableZoom = value);
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
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _currentZoomLevel,
                          min: _minAvailableZoom,
                          max: _maxAvailableZoom,
                          activeColor: Colors.grey,
                          inactiveColor: Colors.black38,
                          thumbColor: Colors.lightBlue,
                          onChanged: (value) async {
                            setState(() {
                              _currentZoomLevel = value;
                            });
                            await controller!.setZoomLevel(value);
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _currentZoomLevel.toStringAsFixed(1) + 'x',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
      onTap: () {
        processTakingPicture();
        print("Picture taken");
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            child: const SizedBox(height: 45, width: 45),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          Container(
            child: const SizedBox(height: 35, width: 35),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.5),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          Container(
            child: const SizedBox(height: 25, width: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ],
      ),
    );
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

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      print(file.path);
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  void processTakingPicture() async {
    XFile? rawImage = await takePicture();
    File imageFile = File(rawImage!.path);

    int currentUnix = DateTime.now().millisecondsSinceEpoch;
    final directory = await getApplicationDocumentsDirectory();
    String fileFormat = imageFile.path.split('.').last;

    await imageFile.copy(
      '${directory.path}/$currentUnix.$fileFormat',
    );
  }
}
