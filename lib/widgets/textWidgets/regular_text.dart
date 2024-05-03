import 'package:flutter/material.dart';
import 'package:sevenapplication/utils/const_app.dart';

class RegularText extends StatelessWidget {
  final String text;
  final Color textColor;
  final String textFamily;
  final double textSize;
  final TextAlign? textAlignement;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;

  RegularText({
    Key? key,
    required this.text,
    this.textColor = Colors.black,
    this.textFamily = "Inter",
    this.textDecoration,
    this.fontWeight,
    this.textSize = 14.0,
    this.textAlignement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlignement,
      style: TextStyle(
        decoration: textDecoration ?? TextDecoration.none,
        color: textColor,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontFamily: ConstApp.fontfamily,
        fontSize: textSize,
      ),
    );
  }
}
