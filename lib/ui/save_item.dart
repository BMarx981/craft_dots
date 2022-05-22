import 'package:craft_dots/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/board_utils.dart';

class SaveItem extends StatelessWidget {
  final String name;

  const SaveItem({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(name, style: const TextStyle(fontSize: 25)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Save button starts here !!!!!
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
                    String board =
                        Provider.of<BoardUtils>(context, listen: false)
                            .boardToString();
                    DBHelper.update(name, board);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("$name Saved.")));
                    Navigator.pop(context);
                  }), // End save button
              //Load button starts here!!!!!!
              GestureDetector(
                  child: const Text(
                    "Load",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    String board = await DBHelper.getData(name: name);
                    Provider.of<BoardUtils>(context, listen: false)
                        .loadBoard(board, context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("$name Loaded.")));
                    Navigator.pop(context);
                  }), // End load button
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: .5)),
    );
  }
}
