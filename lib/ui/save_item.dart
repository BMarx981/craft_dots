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
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name, style: const TextStyle(fontSize: 25)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                          String board =
                              Provider.of<BoardUtils>(context, listen: false)
                                  .boardToString();
                          DBHelper.update(
                              name,
                              board,
                              Provider.of<SettingsModel>(context, listen: false)
                                  .getDotSize);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${name} Saved.")));
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
                          Provider.of<BoardUtils>(context, listen: false)
                              .loadBoard(boardMap[DBHelper.columnCanvas],
                                  boardMap[DBHelper.columnDotSize]);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${name} Loaded.")));
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
                                SnackBar(content: Text("Printing ${name}.")));
                          });
                          Navigator.pop(context);
                        }), // End load button
                  ],
                ),
                FutureBuilder(
                    future: bu.displayBoardImage(name),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Spinner();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('An Error happened');
                        } else if (snapshot.hasData) {
                          return Image.file(
                            snapshot.data as File,
                          );
                        }
                      }
                      return const Text("Nothing to see here");
                    }),
              ],
            ),
          ),
          //Image of the boad goes here.
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: .5)),
    );
  }

  // Future<Image> convertFileToImage(File picture) async {
  //   List<int> imageBase64 = picture.readAsBytesSync();
  //   String imageAsString = base64Encode(imageBase64);
  //   Uint8List uint8list = base64.decode(imageAsString);
  //   Image image = Image.memory(uint8list);
  //   return image;
  // }
}
