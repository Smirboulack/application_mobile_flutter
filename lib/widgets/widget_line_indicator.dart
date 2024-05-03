import 'package:flutter/material.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class WidgetLineIndicator extends StatelessWidget {
  const WidgetLineIndicator({
    Key? key,
    required this.text,
    required this.isCurrentItem,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  final ValueChanged<int> onTap;

  final String text;
  final int index;
  final bool isCurrentItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(index);
      },
      child: isCurrentItem ? _selectedCatText(text) : _unselectedCatText(text),
    );
  }

  Widget _selectedCatText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorsConst.col_app),
          ),
          Container(
            height: 1,
            width: 20,
            color: ColorsConst.col_app_f,
          ),
        ],
      ),
    );
  }

  Widget _unselectedCatText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(
                color: ColorsConst.col_app_f, fontSize: 14, height: 1.55),
          ),
        ],
      ),
    );
  }
}
