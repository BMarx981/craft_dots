import 'package:flutter/material.dart';

class PegBoardWidget extends StatelessWidget {
  const PegBoardWidget({
    Key? key,
    required this.board,
    required this.boardSize,
    required this.dotSize,
  }) : super(key: key);

  final List<Widget> board;
  final int boardSize;
  final int dotSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: board,
      ),
    );
  }
}
