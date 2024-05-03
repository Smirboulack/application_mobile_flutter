import 'package:flutter/material.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class StylesApp {
  static BoxDecoration decoration = BoxDecoration(
    border: Border.all(color: ColorsConst.borderColor),
    color: ColorsConst.background_c,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
  );


  static BoxDecoration decorationNav = BoxDecoration(
    border: Border.all(color: ColorsConst.borderColor),
    color: ColorsConst.col_app,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
  );

  static TextStyle styleTitle = TextStyle(
      fontSize: 20.sp,
      fontFamily: "InterBold",
      color: ColorsConst.col_app_f);


  static TextStyle textStyleM = TextStyle(
      fontSize: 16.sp,
      fontFamily: "InterMedium",
      color: ColorsConst.col_app_black);
}
