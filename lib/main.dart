import 'package:craft_dots/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/dot_lists.dart';
import 'models/settings_model.dart';

void main() {
  runApp(const CraftDots());
}

class CraftDots extends StatelessWidget {
  const CraftDots({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => SM())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Craft Dots',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
