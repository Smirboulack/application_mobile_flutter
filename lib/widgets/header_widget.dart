import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
        child: Container(
            //  padding: EdgeInsets.all(screenSize.width * 0.015),
            color: Colors.grey[200],
            child: Container(
                padding: EdgeInsets.only(top: 36.h, bottom: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/jobs3.png',
                      width: 50.w,
                    ),
                    Container(
                      width: 6.w,
                    ),
                    Text(
                      'SEVEN JOBS',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.05,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ))));
  }
}
