import 'package:flutter/material.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalOffersList extends StatelessWidget {
  const HorizontalOffersList({
    Key? key,
    required this.item,
  }) : super(key: key);

  final List<String> item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, int index) {
          return _buildItem(index);
        },
        itemCount: item.length,
      ),
    );
  }

  Widget _buildItem(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: StylesApp.decoration,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Center(
        child: Text(
          item[index],
          style: StylesApp.textStyleM,
        ),
      ),
    );
  }
}
