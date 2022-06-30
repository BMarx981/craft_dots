import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUtils {
  static void fillFunc(int row, int col, Color color, BuildContext context) {
    print(Provider.of<BoardUtils>(context).getColorLists);
  }
}
