import 'package:flutter/material.dart';

import '../common/board_utils.dart';

class SaveItem extends StatelessWidget {
  final String name;
  final BoardUtils boardUtils = BoardUtils();

  SaveItem({Key? key, required this.name}) : super(key: key);

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
                    String board = boardUtils.boardToString();
                  }),
              GestureDetector(
                  child: const Text(
                    "Load",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    String board = boardUtils.boardToString();
                    print("Load button hit.");
                  }),
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
