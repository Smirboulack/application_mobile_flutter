import 'package:flutter/material.dart';

class BoldTextGreen extends StatelessWidget {
  final String text;
  final Color textColor;
  final String textFamily;
  final double textSize;
  final TextAlign? textAlignement;

  const BoldTextGreen({
    Key? key,
    required this.text,
    this.textColor = const Color.fromRGBO(140, 198, 62, 1),
    this.textFamily = 'Inter',
    this.textSize = 16.0, this.textAlignement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlignement,
      style: TextStyle(
        color: textColor,
        fontFamily: textFamily,
        fontSize: textSize,
      ),
    );
  }
}

