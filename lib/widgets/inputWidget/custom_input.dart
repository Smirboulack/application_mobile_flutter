// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String hintText;
   final TextEditingController myController;
   final int? maxLines;
  const CustomInput({super.key, required this.hintText , required this.myController, this.maxLines});

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late String _hintText;

  @override
  void initState() {
    super.initState();
    _hintText= widget.hintText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.myController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        filled: true,

        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          borderSide: BorderSide(color: Color(0xFF8CC63E)),
        ),
        hintText: _hintText,
        hintStyle: TextStyle(color: Color(0xFF5C5C5C).withOpacity(0.5)),
      ),
      cursorColor: Color(0xFF8CC63E),
      style: TextStyle(fontSize: 16.0, fontFamily: 'Inter'),
      maxLines: widget.maxLines?? 1,
    );
  }
}
