import 'package:camera/camera.dart';
import 'package:craft_dots/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/board_utils.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    // no cameras found
  }
  runApp(const CraftDots());
}

class CraftDots extends StatelessWidget {
  const CraftDots({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => BoardUtils())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Craft Dots',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
        ),
        home: HomePage(),
      ),
    );
  }
}
