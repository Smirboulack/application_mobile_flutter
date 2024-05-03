// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final void Function() onPressed;

  const CustomButton({super.key,required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          fixedSize: Size.fromWidth(200),
          backgroundColor: Color(0xFF8CC63E),
          textStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            
          )),
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}
