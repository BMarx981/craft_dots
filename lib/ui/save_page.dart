import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/models/settings_model.dart';
import 'package:craft_dots/ui/save_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // DBHelper.dropTable();
    DBHelper.createDB().then((_) {
      getAllTheData().then((_) {
        setState(() {});
      });
    });
  }

  Future<void> getAllTheData() async {
    List<Map<String, dynamic>> temp = [];
    temp = await DBHelper.getAllData();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    child: const Text(
                      "Save As",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      String b = Provider.of<BoardUtils>(context, listen: false)
                          .boardToString();
                      TextEditingController controller =
                          TextEditingController();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              title: const Text("Save As"),
                              content: TextField(
                                controller: controller,
                                decoration:
                                    const InputDecoration(hintText: "Name"),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    int dotSize = Provider.of<SettingsModel>(
                                            context,
                                            listen: false)
                                        .getDotSize;
                                    DBHelper.saveAs(
                                        controller.text, b, dotSize);
                                    Provider.of<BoardUtils>(context,
                                            listen: false)
                                        .loadBoard(b, dotSize);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("${controller.text} Saved."),
                                      ),
                                    );
                                    setState(() {
                                      list.add({
                                        'name': controller.text,
                                      });
                                    });
                                  },
                                  child: const Text('SAVE'),
                                ),
                              ],
                            );
                          });
                    }),
              ],
            ),
            const Divider(),
            list.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            onDismissed: (di) async {
                              await DBHelper.delete(list[index]['name']);
                              list.removeAt(index);
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
                              child: SaveItem(name: list[index]['name']),
                            ),
                          );
                        }),
                  )
                : SaveItem(name: 'No Saved data'),
          ],
        ),
      ),
    );
  }
}
