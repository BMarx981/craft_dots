import 'package:craft_dots/models/settings_model.dart';
import 'package:craft_dots/ui/peg_board.dart';
import 'package:craft_dots/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
          statusBarBrightness: Brightness.light, // here what you need
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Craft Dots"),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
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
                  child: Consumer<SM>(
                    builder: (context, settingsModel, child) => PegBoard(
                      boardSize: settingsModel.getSize,
                      dotSize: settingsModel.getDotSize,
                    ),
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
