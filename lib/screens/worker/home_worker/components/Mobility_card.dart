import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/core/models/mobility.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class Mobility_card extends StatelessWidget {
  final Mobility mobility;

  Mobility_card({required this.mobility});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.w, top: 2.h),
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        color: ColorsConst.col_app_f.withOpacity(0.2),

        borderRadius: BorderRadius.circular(
            15), // Set the borderRadius to half of the width or height for a perfect circle
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mobility.name,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
