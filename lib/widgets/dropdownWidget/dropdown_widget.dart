import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onOptionChanged;

  DropdownWidget({required this.options, required this.selectedOption, required this.onOptionChanged});

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  bool _isDropdownOpened = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        border: Border.all(
          color: _isDropdownOpened ? Color(0xFF8CC63E) : Colors.grey,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.grey[200],
          ),
          child: DropdownButton<String>(
            value: widget.selectedOption,
            items: widget.options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(option),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _isDropdownOpened = false;
                widget.onOptionChanged(newValue ?? '');
              });
            },
            style: TextStyle(
              color: Colors.black,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
            onTap: () {
              setState(() {
                _isDropdownOpened = !_isDropdownOpened;
              });
            },
          ),
        ),
      ),
    );
  }
}
