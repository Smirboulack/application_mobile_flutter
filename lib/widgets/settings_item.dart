import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';

class SettingsItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final bool hasArrow;
  final bool hasSwitch;
  final bool isActive;
  final void Function(bool) onChanged;

  SettingsItem(
      {required this.icon,
      required this.text,
      this.hasArrow = true,
      this.hasSwitch = false,
      this.isActive = false,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsetsDirectional.only(
          start: ScreenUtil().setWidth(21).toDouble(),
          end: ScreenUtil().setWidth(21).toDouble(),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(36).toDouble(),
              height: ScreenUtil().setWidth(36).toDouble(),
              padding: EdgeInsets.all(ScreenUtil().setWidth(7).toDouble()),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: icon,
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(13).toDouble()),
            Text(
              text,
              style: StylesApp.textStyleM,
            ),
            Spacer(),

            if (hasSwitch)
              Transform.translate(
                offset: Offset(ScreenUtil().setWidth(12).toDouble(), 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      isActive ? 'On' : 'Off',
                      style: StylesApp.textStyleM,
                    ),
                    SizedBox(width: ScreenUtil().setWidth(12).toDouble()),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: isActive,
                        activeColor: ColorsConst.col_app,
                        onChanged: onChanged,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
