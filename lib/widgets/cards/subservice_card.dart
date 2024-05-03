import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/core/models/emp_service.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';

class SubServiceCard extends StatelessWidget {
  final int index;
  final EmpService service;
  final bool selected;

  SubServiceCard(
      {required this.index, required this.service, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),
//        height: ScreenUtil().setHeight(93).toDouble(),
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(7).toDouble(),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: selected ? ColorsConst.col_app : ColorsConst.background_c,
        boxShadow: [
          BoxShadow(
            color: ColorsConst.borderColor.withOpacity(0.34),
            offset: Offset(1, 1),
            blurRadius: 3,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Transform.translate(
              offset: index % 2 == 0
                  ? Offset(ScreenUtil().setWidth(203.34 / 2).toDouble(), 0)
                  : Offset(ScreenUtil().setWidth(203.34 / 2).toDouble(),
                      -ScreenUtil().setWidth(196 / 2).toDouble()),
              child: Container(
                width: ScreenUtil().setWidth(203.34).toDouble(),
                height: ScreenUtil().setWidth(196).toDouble(),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? ColorsConst.col_app
                      : ColorsConst.background_c,
                ),
              ),
            ),
          ),
          Positioned(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(45).toDouble(),
                vertical: ScreenUtil().setHeight(20).toDouble(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    service.name,
                    style: StylesApp.styleTitle,
                    /* style: selected
                          ? theme.selectedSubServiceNameStyle
                          : theme.subServiceNameStyle,*/
                  ),
                  SizedBox(height: ScreenUtil().setHeight(16).toDouble()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
