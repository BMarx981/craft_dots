import 'dart:typed_data';

import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/ui/peg_board.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import '../common/board_utils.dart';
import '../models/settings_model.dart';

class SaveItem extends StatelessWidget {
  final String name;

  const SaveItem({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name, style: const TextStyle(fontSize: 25)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Save button starts here !!!!!
                GestureDetector(
                    child: const Icon(
                      Icons.save_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onTap: () {
                      String board =
                          Provider.of<BoardUtils>(context, listen: false)
                              .boardToString();
                      DBHelper.update(
                          name,
                          board,
                          Provider.of<SettingsModel>(context, listen: false)
                              .getDotSize);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$name Saved.")));
                      Navigator.pop(context);
                    }), // End save button
                //Load button starts here!!!!!!
                GestureDetector(
                    child: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onTap: () async {
                      Map boardMap = await DBHelper.getData(name: name);
                      Provider.of<BoardUtils>(context, listen: false).loadBoard(
                          boardMap[DBHelper.columnCanvas],
                          boardMap[DBHelper.columnDotSize]);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$name Loaded.")));
                      Navigator.pop(context);
                    }),
                //Print button start here!!!!!!!!
                GestureDetector(
                    child: const Icon(
                      Icons.print_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onTap: () {
                      Provider.of<BoardUtils>(context, listen: false)
                          .printBoard(name)
                          .then((item) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Printing $name.")));
                      });
                      Navigator.pop(context);
                    }), // End load button
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: .5)),
    );
  }
}
