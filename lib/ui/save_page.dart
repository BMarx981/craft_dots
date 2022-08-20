import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/ui/save_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  List<Map<String, dynamic>> list = [];

  @override
  void initState() {
    super.initState();
    list.clear();
    getAllTheData();
  }

  Future<void> getAllTheData() async {
    final db = DBHelper.instance;
    List<Map<String, dynamic>> temp = [];
    temp = await db.getAllData();
    for (Map<String, dynamic> element in temp) {
      setState(() {
        list.add({
          'name': element['name'],
          'canvas': element['canvas'],
          'id': element['id'],
          'dotSize': element['dotSize']
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(text!.saveWork),
      ),
      body: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //**********Save As button*************
                GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color?.lerp(Colors.grey[400], Colors.white, .1)
                                    as Color,
                                Color?.lerp(Colors.white, Colors.grey[100], .2)
                                    as Color,
                              ]),
                          boxShadow: const [
                            // Shadow for top-left corner
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(5, 5),
                              blurRadius: 3,
                              spreadRadius: 1.7,
                            ),

                            // Shadow for bottom-right corner
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-3, -3),
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                          ],
                          border: Border.all(
                            width: 0.5,
                            color: Colors.white,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          text.saveAs,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      String board =
                          Provider.of<BoardUtils>(context, listen: false)
                              .boardToString();
                      TextEditingController controller =
                          TextEditingController();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildAlertDialog(
                                controller, context, board);
                          });
                    }),
              ],
            ),
            const Divider(),
            list.isNotEmpty
                ? Expanded(
                    child: GridView(
                      // itemCount: list.length,
                      children: _gridViewList(list),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 300,
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 10.0,
                      ),
                    ),
                  )
                : SaveItem(name: text.noSavedData),
          ],
        ),
      ),
    );
  }

  //****************Save as Alert dialog****************** */
  AlertDialog _buildAlertDialog(
      TextEditingController controller, BuildContext context, String board) {
    final text = AppLocalizations.of(context);
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      title: Text(text!.saveAs),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: text.name),
      ),
      actions: [
        TextButton(
          onPressed: () {
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
            setState(() {
              list.add({
                'name': controller.text,
              });
            });
          },
          child: Text(text.save),
        ),
      ],
    );
  }

  //********************The list of Save Items ***************/
  List<Widget> _gridViewList(List<Map<String, dynamic>> list) {
    List<Widget> returnList = [];
    for (var item in list) {
      returnList.add(
        Dismissible(
          onDismissed: (di) async {
            final db = DBHelper.instance;
            await db.delete(item['name']);
            list.remove(item);
            setState(() {});
          },
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
            child: const Icon(
              Icons.delete_outline,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SaveItem(name: item['name']),
          ),
        ),
      );
    }
    return returnList;
  }
}
