import 'package:camera/camera.dart';
import 'package:craft_dots/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'common/board_utils.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException {
    // no cameras found
  }
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => BoardUtils())],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
      ),
      home: HomePage(),
    ),
  ));
}
