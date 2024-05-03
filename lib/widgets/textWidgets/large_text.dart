import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  final String text;
  final Color textColor;
  final String textFamily;
  final FontWeight textWeight;
  final double textSize;

  const LargeText({
    Key? key,
    required this.text,
    this.textColor = Colors.black,
    this.textFamily = 'Inter',
    this.textWeight = FontWeight.bold,
    this.textSize = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontFamily: textFamily,
        fontSize: textSize,
        fontWeight: textWeight,
      ),
    );
  }
}