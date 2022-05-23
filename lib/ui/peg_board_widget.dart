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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: (boardSize * dotSize).toDouble(),
        height: (boardSize * dotSize).toDouble(),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return board[index];
          },
          itemCount: board.length,
        ),
      ),
    );
  }
}
