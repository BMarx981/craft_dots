import 'package:camera/camera.dart';
import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/ui/peg_board.dart';
import 'package:craft_dots/ui/save_page.dart';
import 'package:craft_dots/ui/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'image_picker_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key) {
    getCameras();
  }

  late List<CameraDescription> cameras;

  void getCameras() async {
    cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dot Pic"),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.photo_fill),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ImagePickerPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SavePage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
              child: Center(
                child: PegBoard(
                  boardSize: Provider.of<BoardUtils>(context, listen: false)
                      .getBoardSize,
                  dotSize: Provider.of<BoardUtils>(context, listen: false)
                      .getDotSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
