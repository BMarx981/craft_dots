import 'package:camera/camera.dart';
import 'package:craft_dots/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('es', ''), // Spanish, no country code
          Locale('de', ''), // German, no country code
          Locale('zh', ''), // Chinese, no country code
          Locale('ja', ''), // Japanese, no country code
          Locale('iw', ''), // Jewish, no country code
          Locale('ar', ''), // Arabic, no country code
          Locale('nl', ''), // Dutch, no country code
          Locale('hi', ''), // Hinidi, no country code
          Locale('ko', ''), // Korean, no country code
          Locale('tr', ''), // Turkish, no country code
          Locale('th', ''), // Thai, no country code
          Locale('uk', ''), // Ukrainian, no country code
          Locale('ji', ''), // yiddish, no country code
          Locale('vi', ''), // Vietnamese, no country code
        ],
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
