import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/settings_model.dart';

class EditUtils {
  static void fillFunc(int row, int col, Color color, BuildContext context) {
    print("Row $row Col $col");
  }

  static void clearBoard(BuildContext context) {
    Provider.of<BoardUtils>(context, listen: false)
        .clearBoard(Provider.of<SettingsModel>(context, listen: false).getSize);
  }
}
