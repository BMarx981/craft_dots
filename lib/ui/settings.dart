import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController boardSizeController = TextEditingController();
  TextEditingController dotSizeController = TextEditingController();
  String _currentSize = "";
  String _currentDotSize = "";
  Map<Color, int> stats = {};
  List<Color> keys = [];
  bool textEnteredBoardSize = false;
  bool textEnteredDotSize = false;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    stats = Provider.of<BoardUtils>(context, listen: false).getColorCount();
    keys = stats.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(text!.settings),
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
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
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
                            if (str != "") {
                              setState(() {
                                textEnteredBoardSize = true;
                              });
                            }
                            if (str == "") {
                              setState(() {
                                textEnteredBoardSize = false;
                              });
                              _currentSize = str;
                              return;
                            }
                            if (int.parse(str).isNaN) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(text.mustBeNum)));
                            }
                            _currentSize = str;
                          },
                          controller: boardSizeController,
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
                            Color?.lerp(
                                textEnteredBoardSize
                                    ? Colors.green[400]
                                    : Colors.grey,
                                Colors.white,
                                .1) as Color,
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
                          setState(() {
                            textEnteredBoardSize = false;
                            boardSizeController.text = "";
                          });
                          Provider.of<BoardUtils>(context, listen: false)
                              .updateSize(int.parse(_currentSize));
                          FocusScope.of(context).unfocus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            text.boardSize,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: textEnteredBoardSize
                                  ? Colors.black
                                  : Colors.grey[600],
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
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
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
                          debugPrint(str);
                          if (str != "") {
                            setState(() {
                              textEnteredDotSize = true;
                            });
                          }
                          if (str == "") {
                            setState(() {
                              textEnteredDotSize = true;
                            });
                            _currentDotSize = str;
                            return;
                          }
                          if (int.parse(str).isNaN) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(text.mustBeNum)));
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
                            Color?.lerp(
                                textEnteredDotSize
                                    ? Colors.green[400]
                                    : Colors.grey,
                                Colors.white,
                                .1) as Color,
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
                          setState(() {
                            textEnteredDotSize = false;
                            dotSizeController.text = "";
                          });
                          Provider.of<BoardUtils>(context, listen: false)
                              .updateDotSize(int.parse(_currentDotSize));
                          FocusScope.of(context).unfocus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            children: [
                              Text(
                                text.dotSize,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: textEnteredDotSize
                                      ? Colors.black
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
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
                        Text("${text.totalColors} ${keys.length}",
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Stats:",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(text.color),
                        Text(text.count),
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
