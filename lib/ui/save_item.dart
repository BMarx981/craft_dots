import 'dart:io';

import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/ui/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import '../common/board_utils.dart';

class SaveItem extends StatefulWidget {
  String name = "";

  SaveItem({Key? key, required this.name}) : super(key: key);

  @override
  State<SaveItem> createState() => _SaveItemState();
}

class _SaveItemState extends State<SaveItem> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    imageCache?.clear();
  }

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
                _controller.text = widget.name;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildAlertDialog(
                          _controller,
                          context,
                          Provider.of<BoardUtils>(context, listen: false)
                              .boardToString());
                    });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.name, style: const TextStyle(fontSize: 25)),
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
                          widget.name,
                          board,
                          Provider.of<BoardUtils>(context, listen: false)
                              .getDotSize);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${widget.name} Saved.")));
                      Navigator.pop(context);
                    }), // End save button

                //Print button start here!!!!!!!!
                GestureDetector(
                    child: const Icon(
                      Icons.print_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onTap: () {
                      Provider.of<BoardUtils>(context, listen: false)
                          .printBoard(widget.name)
                          .then((item) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Printing ${widget.name}.")));
                      });
                      Navigator.pop(context);
                    }), // End load button
              ],
            ),
            FutureBuilder(
                future: Provider.of<BoardUtils>(context, listen: false)
                    .displayBoardImage(widget.name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Spinner(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('');
                    } else if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () async {
                          final db = DBHelper.instance;
                          Map boardMap = await db.getData(name: widget.name);
                          Provider.of<BoardUtils>(context, listen: false)
                              .loadBoard(boardMap[DBHelper.columnCanvas],
                                  boardMap[DBHelper.columnDotSize]);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${widget.name} Loaded.")));
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
          ],
        ),
      ),
    );
  }

  AlertDialog _buildAlertDialog(
      TextEditingController controller, BuildContext context, String board) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      title: const Text("Rename"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: widget.name),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.name = controller.text;
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            int dotSize =
                Provider.of<BoardUtils>(context, listen: false).getDotSize;
            DBHelper.saveAs(controller.text, board, dotSize);
            Provider.of<BoardUtils>(context, listen: false)
                .loadBoard(board, dotSize);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${controller.text} Saved."),
              ),
            );
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
