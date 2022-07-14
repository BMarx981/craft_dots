import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:craft_dots/ui/preview_screen.dart';
import 'package:craft_dots/ui/spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

import '../common/board_utils.dart';
import '../main.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

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
  String imageFilePath = '';

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
      //The camera threw and exception
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
        Navigator.pop(context);
        Navigator.pop(context);
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
        return CupertinoIcons.arrow_2_circlepath;
      case CameraLensDirection.front:
        return Icons.change_circle_outlined;
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
      return file;
    } on CameraException catch (e) {
      return null;
    }
  }

  void processTakingPicture() async {
    XFile? rawImage = await takePicture();
    if (rawImage == null) return;
    Uint8List bytes = File(rawImage.path).readAsBytesSync();
    List<Color> list = extractPixelsColors(bytes);
    Provider.of<BoardUtils>(context, listen: false).loadBoardFromPic(list);
  }

  List<Color> extractPixelsColors(Uint8List? bytes) {
    int noOfPixelsPerAxis = 29;
    List<Color> colors = [];

    List<int> values = bytes!.buffer.asUint8List();
    img.Image? image = img.decodeImage(values);

    int? width = image?.width;
    int? height = image?.height;

    List<int?> pixels = [];

    int xChunk = width! ~/ (noOfPixelsPerAxis + 1);
    int yChunk = height! ~/ (noOfPixelsPerAxis + 1);

    for (int j = 1; j < noOfPixelsPerAxis + 1; j++) {
      for (int i = 1; i < noOfPixelsPerAxis + 1; i++) {
        int? pixel = image?.getPixel(xChunk * i, yChunk * j);
        pixels.add(pixel);
        colors.add(abgrToColor(pixel!));
      }
    }

    return colors;
  }

  Color abgrToColor(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    int hex = (argbColor & 0xFF00FF00) | (b << 16) | r;
    return Color(hex);
  }
}
