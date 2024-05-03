import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/images.dart';

class CustomNavItem extends StatelessWidget {
  const CustomNavItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.isSelected,
    Color? selectedColor,
    Color? unselectedColor,
  })  : _selectedColor = selectedColor,
        _unselectedColor = unselectedColor,
        super(key: key);

  final String text;
  final Widget icon;
  final bool isSelected;
  final Color? _selectedColor;
  final Color? _unselectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Tooltip(
        message: text,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 4.h),
                  icon,
                  SizedBox(height: 4.h),
                  Text(text,
                      style: TextStyle(
                          color: isSelected ? _selectedColor : _unselectedColor,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: isSelected ? 11.5.sp : 11.0.sp)),
                  SizedBox(height: 8.h),
                ]),
            if (isSelected)
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: SvgPicture.asset(AppImages.indicator,
                    color: ColorsConst.background_c),
              ),
          ],
        ),
      ),
    );
  }
}
