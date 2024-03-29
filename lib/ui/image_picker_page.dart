import 'package:craft_dots/ui/camera_page.dart';
import 'package:craft_dots/ui/peg_board_widget.dart';
import 'package:craft_dots/ui/spinner.dart';
import 'package:craft_dots/common/board_utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:io';
import 'dart:typed_data';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key}) : super(key: key);

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  bool isBoardLoaded = false;

  @override
  initState() {
    super.initState();
    getImage();
  }

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
      );
      if (image == null) return;
      Uint8List bytes = File(image.path).readAsBytesSync();
      List<Color> list = extractPixelsColors(bytes);
      Provider.of<BoardUtils>(context, listen: false).loadBoardFromPic(list);
    } catch (e) {
      // e.toString()
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(text!.imageGallery),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CameraPage()));
              },
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.photo_fill),
              onPressed: () {
                getImage();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: isBoardLoaded
                ? PegBoardWidget(
                    board:
                        Provider.of<BoardUtils>(context, listen: false).board,
                    boardSize: Provider.of<BoardUtils>(context, listen: false)
                        .getBoardSize,
                    dotSize: Provider.of<BoardUtils>(context, listen: false)
                        .getDotSize,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Spinner(),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }

  List<Color> extractPixelsColors(Uint8List? bytes) {
    int noOfPixelsPerAxis =
        Provider.of<BoardUtils>(context, listen: false).getBoardSize;
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
