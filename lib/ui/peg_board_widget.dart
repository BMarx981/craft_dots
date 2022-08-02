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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: (boardSize * dotSize) < constraints.maxWidth
              ? (boardSize * dotSize * 1.0)
              : (constraints.maxWidth),
          height: (boardSize * dotSize) < constraints.maxHeight
              ? (boardSize * dotSize * 1.0)
              : (constraints.maxHeight),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return board[index];
            },
            itemCount: board.length,
          ),
        );
      },
    );
  }
}
