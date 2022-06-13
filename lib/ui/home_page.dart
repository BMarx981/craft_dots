import 'package:craft_dots/ui/peg_board.dart';
import 'package:craft_dots/ui/save_page.dart';
import 'package:craft_dots/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/settings_model.dart';
import 'camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Craft Dots"),
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
                    boardSize:
                        Provider.of<SettingsModel>(context, listen: false)
                            .getSize,
                    dotSize: Provider.of<SettingsModel>(context, listen: false)
                        .getDotSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
