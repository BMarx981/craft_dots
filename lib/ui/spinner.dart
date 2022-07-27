import 'dart:math';

import 'package:flutter/material.dart';

class Spinner extends StatefulWidget {
  const Spinner({Key? key}) : super(key: key);

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> {
  final List<Color> list = [
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.pink,
    Colors.black,
    Colors.purple,
    Colors.deepOrange
  ];

  Color chosenColor1 = Colors.blue;
  Color chosenColor2 = Colors.blue;
  Color chosenColor3 = Colors.blue;
  Color chosenColor4 = Colors.blue;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3))
        .then((value) => setState(() {
              _chooseANewColor();
            }));
  }

  @override
  Widget build(BuildContext context) {
    _chooseANewColor();
    return Column(
      children: [
        Row(
          children: [
            AnimatedContainer(
              child: const SizedBox(height: 35, width: 35),
              decoration: BoxDecoration(
                color: chosenColor1,
                borderRadius: BorderRadius.circular(35),
              ),
              onEnd: () {
                setState(() {
                  _chooseANewColor();
                });
              },
              duration: const Duration(
                milliseconds: 1500,
              ),
            ),
            AnimatedContainer(
              child: const SizedBox(height: 35, width: 35),
              decoration: BoxDecoration(
                color: chosenColor2,
                borderRadius: BorderRadius.circular(35),
              ),
              onEnd: () {
                setState(() {
                  _chooseANewColor();
                });
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
              child: const SizedBox(height: 35, width: 35),
              decoration: BoxDecoration(
                color: chosenColor3,
                borderRadius: BorderRadius.circular(35),
              ),
              onEnd: () {
                setState(() {
                  _chooseANewColor();
                });
              },
              duration: const Duration(
                milliseconds: 1500,
              ),
            ),
            AnimatedContainer(
              child: const SizedBox(height: 35, width: 35),
              decoration: BoxDecoration(
                color: chosenColor4,
                borderRadius: BorderRadius.circular(35),
              ),
              onEnd: () {
                setState(() {
                  _chooseANewColor();
                });
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
    Random r = Random();
    chosenColor1 = list[r.nextInt(list.length - 1)];
    chosenColor2 = list[r.nextInt(list.length - 1)];
    chosenColor3 = list[r.nextInt(list.length - 1)];
    chosenColor4 = list[r.nextInt(list.length - 1)];
  }
}
