import 'dart:math';

import 'package:flutter/material.dart';

class Spinner extends StatefulWidget {
  Spinner({Key? key}) : super(key: key);

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> {
  final List<Color> list = [
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.white,
    Colors.black,
    Colors.purple,
    Colors.deepOrange
  ];

  @override
  void initState() {
    _chooseANewColor();
    super.initState();
  }

  Color chosenColor1 = Colors.blue;
  Color chosenColor2 = Colors.blue;
  Color chosenColor3 = Colors.blue;
  Color chosenColor4 = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AnimatedContainer(
              child: const SizedBox(height: 75, width: 75),
              decoration: BoxDecoration(
                color: chosenColor1,
                borderRadius: BorderRadius.circular(35),
              ),
              onEnd: () {
                _chooseANewColor();
              },
              duration: const Duration(
                milliseconds: 1500,
              ),
            ),
            AnimatedContainer(
              child: const SizedBox(height: 75, width: 75),
              decoration: BoxDecoration(
                color: chosenColor2,
                borderRadius: BorderRadius.circular(35),
              ),
              onEnd: () {
                _chooseANewColor();
              },
              duration: const Duration(
                milliseconds: 1500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            AnimatedContainer(
              child: const SizedBox(height: 75, width: 75),
              decoration: BoxDecoration(
                color: chosenColor3,
                borderRadius: BorderRadius.circular(35),
              ),
              onEnd: () {
                _chooseANewColor();
              },
              duration: const Duration(
                milliseconds: 1500,
              ),
            ),
            AnimatedContainer(
              child: const SizedBox(height: 75, width: 75),
              decoration: BoxDecoration(
                color: chosenColor4,
                borderRadius: BorderRadius.circular(35),
              ),
              onEnd: () {
                _chooseANewColor();
              },
              duration: const Duration(
                milliseconds: 1500,
              ),
            ),
          ],
        )
      ],
    );
  }

  _chooseANewColor() {
    final r = Random();
    setState(() {
      chosenColor1 = list[r.nextInt(list.length - 1)];
      chosenColor2 = list[r.nextInt(list.length - 1)];
      chosenColor3 = list[r.nextInt(list.length - 1)];
      chosenColor4 = list[r.nextInt(list.length - 1)];
    });
  }
}
