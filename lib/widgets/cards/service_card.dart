import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/core/models/emp_service.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';

class ServiceCard extends StatelessWidget {
  final int index;
  final EmpService service;

  ServiceCard({required this.index, required this.service});

  double _getCardHeight(TextDirection textDirection) {
    final textSpan = TextSpan(
      text: 'A\nA',
      style: StylesApp.textStyleM,
      children: [
        TextSpan(
          text: 'A\nA\nA',
          style: StylesApp.textStyleM,
        ),
      ],
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: textDirection,
    );
    textPainter.layout();

    return ScreenUtil().setHeight(21 * 2).toDouble() +
        textPainter.height +
        ScreenUtil().setHeight(12).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = _getCardHeight(Directionality.of(context));

    return Container(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),
      height: cardHeight*0.7,
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16).toDouble(),
      ),
      decoration: StylesApp.decoration,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Transform.translate(
              offset: index % 2 == 0
                  ? Offset(ScreenUtil().setWidth(cardHeight).toDouble(), 0)
                  : Offset(ScreenUtil().setWidth(cardHeight).toDouble(),
                      -ScreenUtil().setWidth(cardHeight).toDouble()),
              child: Container(
                width: ScreenUtil().setWidth(cardHeight * 2).toDouble(),
                height: ScreenUtil().setWidth(cardHeight*2).toDouble(),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsConst.col_app_black.withOpacity(0.04),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.asset(service.icon!, width: 64.w,),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        service.name,
                        style: StylesApp.styleTitle,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(12).toDouble()),

                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
//                      child: ,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
