import 'package:craft_dots/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController sizeController = TextEditingController();

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
          title: const Text("Settings"),
        ),
        body: SafeArea(
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.2),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onSubmitted: (str) {
                      Provider.of<SM>(context).updateSize(int.parse(str));
                    },
                    controller: sizeController,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
          ]),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Center(
          //     child: Column(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Container(
          //             padding: const EdgeInsets.all(8.0),
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(25),
          //                 color: Colors.blue.withOpacity(.2)),
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Row(
          //                 children: [
          //                   const Icon(Icons.menu),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: TextField(
          //                       keyboardType: TextInputType.number,
          //                       decoration: const InputDecoration(
          //                         // border: OutlineInputBorder(
          //                         //   borderRadius: BorderRadius.circular(25.0),
          //                         //   borderSide: const BorderSide(),
          //                         // ),
          //                         label: Text("Enter size here."),
          //                         // labelText: "Enter size here",
          //                       ),
          //                       maxLength: 3,
          //                       controller: sizeController,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
