import 'package:flutter/material.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/horizontal_options.dart';
import 'package:sevenapplication/widgets/textWidgets/regular_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: screenSize.width * 0.02),
      height: screenSize.height * 0.25,
      color: ColorsConst.background_c,
      width: screenSize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: RegularText(
              text: "Cadre légal",
              textSize: 13.5.sp,
              textColor: ColorsConst.col_app,
              textDecoration: TextDecoration.underline,
            ),
          ),
          Container(
            height: 12.h,
          ),
          InkWell(
            child: RegularText(
              text: "Mentions légales",
              textSize: 13.5.sp,
            ),
          ),
          Container(
            height: 12.h,
          ),
          InkWell(
            child: RegularText(
              text: "Politique de confidentialité",
              textSize: 13.5.sp,
            ),
          ),
          Container(
            height: 12.h,
          ),
          InkWell(
              child: RegularText(
            text: "Conditions générales d’utilisation",
            textSize: 13.5.sp,
          )),
          Container(
            height: 20.h,
          ),
          HorizontalOptions()
        ],
      ),
    );
  }
}
