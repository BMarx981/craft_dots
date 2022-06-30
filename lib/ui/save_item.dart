import 'dart:io';

import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/ui/spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/board_utils.dart';
import '../models/settings_model.dart';

class SaveItem extends StatelessWidget {
  final String name;

  SaveItem({Key? key, required this.name}) : super(key: key);

  final BoardUtils bu = BoardUtils();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPress: () {
                //TODO
                print("Do something with editing the name");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(name, style: const TextStyle(fontSize: 25)),
              ),
            ),
            Row(
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
                      final db = DBHelper.instance;
                      String board =
                          Provider.of<BoardUtils>(context, listen: false)
                              .boardToString();
                      db.update(
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
                      final db = DBHelper.instance;
                      Map boardMap = await db.getData(name: name);
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
            FutureBuilder(
                future: bu.displayBoardImage(name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Spinner(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('An Error happened');
                    } else if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () async {
                          final db = DBHelper.instance;
                          Map boardMap = await db.getData(name: name);
                          Provider.of<BoardUtils>(context, listen: false)
                              .loadBoard(boardMap[DBHelper.columnCanvas],
                                  boardMap[DBHelper.columnDotSize]);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("$name Loaded.")));
                          Navigator.pop(context);
                        },
                        child: Image.file(
                          snapshot.data as File,
                        ),
                      );
                    }
                  }
                  return const Text("Nothing to see here");
                }),
            //Image of the boad goes here.
          ],
        ),
      ),
    );
  }
}
