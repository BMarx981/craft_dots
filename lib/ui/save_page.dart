import 'package:flutter/material.dart';

class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
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
                  print("on Tap hit.");
                }),
          ],
        ),
      ),
    );
  }
}
