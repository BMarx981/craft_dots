import 'package:craft_dots/common/board_utils.dart';
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade300,
                    offset: const Offset(5, 5),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: 30,
                      child: TextField(
                          decoration: InputDecoration(
                              hintText: Provider.of<BoardUtils>(context)
                                  .getBoardSize
                                  .toString()),
                          textAlign: TextAlign.center,
                          onSubmitted: (str) {
                            Provider.of<BoardUtils>(context, listen: false)
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
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color?.lerp(Colors.green[400], Colors.white, .1)
                                as Color,
                            Color?.lerp(Colors.white, Colors.green[100], .2)
                                as Color,
                          ]),
                      boxShadow: [
                        // Shadow for top-left corner
                        BoxShadow(
                          color: Colors.green.shade300,
                          offset: const Offset(5, 5),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                        // Shadow for bottom-right corner
                        const BoxShadow(
                          color: Colors.white54,
                          offset: Offset(-4, -4),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        width: 0.6,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<BoardUtils>(context, listen: false)
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade300,
                    offset: const Offset(5, 5),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: 30,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: Provider.of<BoardUtils>(context)
                                .getDotSize
                                .toString()),
                        textAlign: TextAlign.left,
                        onSubmitted: (str) {
                          Provider.of<BoardUtils>(context, listen: false)
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
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color?.lerp(Colors.green[400], Colors.white, .1)
                                as Color,
                            Color?.lerp(Colors.white, Colors.green[100], .2)
                                as Color,
                          ]),
                      boxShadow: [
                        // Shadow for top-left corner
                        BoxShadow(
                          color: Colors.green.shade300,
                          offset: const Offset(5, 5),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                        // Shadow for bottom-right corner
                        const BoxShadow(
                          color: Colors.white54,
                          offset: Offset(-4, -4),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        width: 0.6,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<BoardUtils>(context, listen: false)
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
                color: Colors.green.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade300,
                    offset: const Offset(5, 5),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Total Colors: ${keys.length}",
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Stats:",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text("Color"),
                        Text("Count"),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
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
