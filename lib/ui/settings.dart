import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController sizeController = TextEditingController();
  TextEditingController dotSizeController = TextEditingController();
  String _currentSize = "";
  String _currentDotSize = "";
  Map<Color, int> stats = {};
  List<Color> keys = [];

  @override
  Widget build(BuildContext context) {
    stats = Provider.of<BoardUtils>(context, listen: false).getColorCount();
    keys = stats.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
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
                              hintText: Provider.of<SettingsModel>(context,
                                      listen: false)
                                  .getSize
                                  .toString()),
                          textAlign: TextAlign.left,
                          onSubmitted: (str) {
                            Provider.of<SettingsModel>(context, listen: false)
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
                          // maxLength: 3,
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
                          Provider.of<SettingsModel>(context, listen: false)
                              .updateSize(int.parse(_currentSize));
                          FocusScope.of(context).unfocus();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Text(
                              "Board Size",
                              style: TextStyle(
                                fontSize: 30,
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
                color: Colors.green.shade100,
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
                              hintText: Provider.of<SettingsModel>(context,
                                      listen: false)
                                  .getDotSize
                                  .toString()),
                          textAlign: TextAlign.center,
                          onSubmitted: (str) {
                            Provider.of<SettingsModel>(context, listen: false)
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
                          Provider.of<SettingsModel>(context, listen: false)
                              .updateDotSize(int.parse(_currentDotSize));
                          FocusScope.of(context).unfocus();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Text(
                              "Dot Size",
                              style: TextStyle(
                                fontSize: 30,
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: Colors.green.shade100),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Stats:",
                      style: TextStyle(fontSize: 18),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: Text(stats[keys[index]].toString()),
                          tileColor: Colors.green.shade200,
                          title: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                  child: Text(keys[index].value.toString())),
                            ),
                            decoration: BoxDecoration(
                              color: keys[index],
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
