import 'package:craft_dots/models/settings_model.dart';
import 'package:flutter/cupertino.dart';
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
  TextEditingController dotSizeController = TextEditingController();
  String _currentSize = "";
  String _currentDotSize = "";

  @override
  Widget build(BuildContext context) {
    //AnnotaedRegion is for a light colored safeArea
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
          statusBarBrightness:
              Brightness.light, // here's where the white color is sets
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        width: 50,
                        child: TextField(
                            decoration: InputDecoration(
                                hintText: Provider.of<SM>(context)
                                    .getSize
                                    .toString()),
                            textAlign: TextAlign.center,
                            onSubmitted: (str) {
                              Provider.of<SM>(context)
                                  .updateSize(int.parse(_currentSize));
                            },
                            onChanged: (str) {
                              if (int.parse(str).isNaN) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Must be a number.")));
                              }
                              _currentSize = str;
                            },
                            controller: sizeController,
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.go),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<SM>(context, listen: false)
                                .updateSize(int.parse(_currentSize));
                            FocusScope.of(context).unfocus();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Text(
                                "Board Size",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.2),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        width: 50,
                        child: TextField(
                            decoration: InputDecoration(
                                hintText: Provider.of<SM>(context)
                                    .getDotSize
                                    .toString()),
                            textAlign: TextAlign.center,
                            onSubmitted: (str) {
                              Provider.of<SM>(context)
                                  .updateDotSize(int.parse(_currentDotSize));
                            },
                            onChanged: (str) {
                              if (int.parse(str).isNaN) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Must be a number.")));
                              }
                              _currentDotSize = str;
                            },
                            controller: dotSizeController,
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.go),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<SM>(context, listen: false)
                                .updateDotSize(int.parse(_currentDotSize));
                            FocusScope.of(context).unfocus();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Text(
                                "Dot Size",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
