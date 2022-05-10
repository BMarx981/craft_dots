import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/ui/save_item.dart';
import 'package:flutter/material.dart';

class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  BoardUtils boardUtils = BoardUtils();
  int? dbRowCount = 0;

  @override
  void initState() {
    super.initState();
    DBHelper.createDB();
  }

  Future<void> getRowCount() async {
    dbRowCount = await DBHelper.queryRowCount();
    setState(() {});
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      String b = boardUtils.boardToString();
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
                                    DBHelper.save(controller.text, b);
                                    Navigator.pop(context);
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${controller.text} Saved.")));
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
            FutureBuilder(
              future: DBHelper.queryAllRows(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>>? list = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Dismissible(
                          onDismissed: (di) {
                            setState(() {
                              DBHelper.delete(list![index]['name']);
                              list.removeAt(index);
                            });
                          },
                          key: Key(index.toString()),
                          background: Container(
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete_outline,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SaveItem(name: list![index]['name']),
                          ),
                        );
                      },
                      itemCount: list?.length,
                    ),
                  );
                }
                return SaveItem(name: "Nothing saved ");
              },
            )
          ],
        ),
      ),
    );
  }
}
