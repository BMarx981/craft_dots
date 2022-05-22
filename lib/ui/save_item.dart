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
                  child: const Icon(Icons.save_outlined, color: Colors.blue),
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
                  child: const Icon(Icons.edit, color: Colors.blue),
                  onTap: () async {
                    String board = await DBHelper.getData(name: name);
                    Provider.of<BoardUtils>(context, listen: false)
                        .loadBoard(board, context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("$name Loaded.")));
                    Navigator.pop(context);
                  }),
              GestureDetector(
                  child: const Icon(Icons.print_outlined, color: Colors.blue),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Printing $name.")));
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
