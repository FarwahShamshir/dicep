// widgets/dice_widget.dart
import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final int diceValue;

  DiceWidget({this.diceValue = 1});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/dice$diceValue.jpg',  // Assumes dice images are named dice1.png, dice2.png, etc.
      width: 100,
      height: 100,
    );
  }
}
