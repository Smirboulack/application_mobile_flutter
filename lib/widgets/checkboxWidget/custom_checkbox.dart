// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({Key? key, required this.value, required this.onChanged}) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      side: BorderSide(width: 1.5, color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
          bottomLeft: Radius.circular(6),
        ),
      ),
      activeColor: Color(0xFF8CC63E),
      checkColor: Colors.black,
      value: _value,
      onChanged: (value) {
        setState(() {
          _value = value!;
          widget.onChanged?.call(value);
        });
      },
    );
  }
}




