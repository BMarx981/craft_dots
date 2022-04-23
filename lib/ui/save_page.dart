import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';

class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  BoardUtils boardUtils = BoardUtils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  print("OnTap hit.");
                  String output = "";
                  for (int i = 0; i < boardUtils.getColorLists.length; i++) {
                    for (int j = 0;
                        j < boardUtils.getColorLists[i].length;
                        j++) {
                      output += boardUtils.getColorLists[i][j].value
                              .toRadixString(16) +
                          " ";
                    }
                  }
                  print(output);
                }),
          ],
        ),
      ),
    );
  }
}
