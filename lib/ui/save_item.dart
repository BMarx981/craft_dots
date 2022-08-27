// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/ui/spinner.dart';

import '../common/board_utils.dart';

class SaveItem extends StatefulWidget {
  String name = "";

  SaveItem({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<SaveItem> createState() => _SaveItemState();
}

class _SaveItemState extends State<SaveItem> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    imageCache.clear();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return IntrinsicHeight(
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                //**************Long press to Rename Save Item *******/
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
                  child:
                      Text(widget.name, style: const TextStyle(fontSize: 25)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ******** Save button **************//
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${widget.name} ${text!.saved}")));
                          Navigator.pop(context);
                        }), // End save button

                    //**************** Print button *****************/
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
                                content:
                                    Text("${text!.printing} ${widget.name}.")));
                          });
                          Navigator.pop(context);
                        }), // End load button
                  ],
                ),
              ),
              FutureBuilder(
                  future: Provider.of<BoardUtils>(context, listen: false)
                      .displayBoardImage(widget.name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Spinner(),
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text(text!.nothingHere);
                      } else if (snapshot.hasData) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final db = DBHelper.instance;
                              Map boardMap =
                                  await db.getData(name: widget.name);
                              Provider.of<BoardUtils>(context, listen: false)
                                  .loadBoard(boardMap[DBHelper.columnCanvas],
                                      boardMap[DBHelper.columnDotSize]);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "${widget.name} ${text!.loaded}")));
                              Navigator.pop(context);
                            },
                            child: Image.file(
                              snapshot.data as File,
                            ),
                          ),
                        );
                      }
                    }
                    return Text(text!.nothingHere);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  //****** Rename Alert Dialog *******/
  AlertDialog _buildAlertDialog(
      TextEditingController controller, BuildContext context, String board) {
    final text = AppLocalizations.of(context);
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      title: Text(text!.rename),
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
          child: Text(text.cancel),
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
                content: Text("${controller.text} ${text.saved}"),
              ),
            );
          },
          child: Text(text.save),
        ),
      ],
    );
  }
}
