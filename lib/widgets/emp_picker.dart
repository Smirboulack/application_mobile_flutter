import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';



class EmpTimePicker extends StatefulWidget {
  final DateTime currentDate;

  EmpTimePicker({Key? key, required this.currentDate}) : super(key: key);

  @override
  _EmpTimePickerPickerState createState() => _EmpTimePickerPickerState();
}

class _EmpTimePickerPickerState extends State<EmpTimePicker> {
  PageController? _pageController;
  FixedExtentScrollController? _scrollController;
  double? _page = 0.0;
  int _currentPage = 0;

  double _calculateRouletteHeight(TextDirection textDirection) {
    final textSpan = TextSpan(
      text: '0',
    //  style: theme.timePickerTextStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: textDirection,
    );
    textPainter.layout();

    final textHeight = textPainter.height;
    final padding = ScreenUtil().setHeight(12).toDouble() * 2;

    return textHeight + padding;
  }

  double _mapToInterval(
      double value, double a1, double b1, double a2, double b2) {
    final result = (value - a1) * (b2 - a2) / (b1 - a1) + a2;
    return result;
  }

  @override
  void initState() {
    super.initState();

    _currentPage = widget.currentDate.hour;
    _page = _currentPage.toDouble();
    _pageController =
        PageController(initialPage: 1000 + _currentPage, viewportFraction: 0.2);
    _pageController!.addListener(() {
      if (_pageController!.page != null) {
        setState(() {
          _page = _pageController!.page! - 1000;
        });
      }
    });

    _scrollController = FixedExtentScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset != null) {
        setState(() {
          _page = _scrollController!.offset;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

        final rouletteHeight =
        _calculateRouletteHeight( Directionality.of(context));

        return Container(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 0.2,
                         // color: Palette.ebonyClay,
                        ),
                      ),
                      SvgPicture.asset('assets/icons/cal.svg'),
                      Expanded(
                        child: Container(
                          height: 0.2,
                       //   color: Palette.ebonyClay,
                        ),
                      ),
                    ],
                  ),
//                  SizedBox(
//                    height: rouletteHight,
//                    child: ListView.builder(
//                      controller: _scrollController,
//                      physics: FixedExtentScrollPhysics(),
//                      padding: EdgeInsets.symmetric(
//                        horizontal: ScreenUtil().setWidth(20).toDouble(),
//                      ),
//                      scrollDirection: Axis.horizontal,
//                      itemBuilder: (BuildContext context, int index) {
//                        final isCurrentPage = index == _currentPage;
//                        final distance = (index - _page).abs();
//                        final rotation = asin(distance / 3);
//                        final opacity =
//                            1 / _mapToInterval(distance, 0, 3, 1, 4);
//                        final sign = (index == _page)
//                            ? 1.0
//                            : (index - _page) / (index - _page).abs();
//
//                        return Container(
//                          alignment: Alignment.center,
//                          child: Transform(
//                            alignment: FractionalOffset.center,
//                            transform: Matrix4(
//                              1.0,
//                              0.0,
//                              0.0,
//                              0.0,
//                              0.0,
//                              1.0,
//                              0.0,
//                              0.0,
//                              0.0,
//                              0.0,
//                              1.0,
//                              -sign * rotation / 1000,
//                              0.0,
//                              0.0,
//                              0.0,
//                              1.0,
//                            )..rotateY(rotation),
//                            child: Opacity(
//                              opacity: opacity,
//                              child: Container(
//                                alignment: Alignment.center,
////                                width: ScreenUtil().setWidth(77).toDouble(),
////                                padding: EdgeInsets.symmetric(
////                                  vertical:
////                                      ScreenUtil().setHeight(12).toDouble(),
//////                                  horizontal:
//////                                      ScreenUtil().setWidth(8).toDouble(),
////                                ),
//                                child: Text(
//                                  '12:00',
//                                  style: theme.timePickerTextStyle.copyWith(
//                                    fontSize: 21,
//                                    fontWeight: isCurrentPage
//                                        ? FontWeight.w700
//                                        : FontWeight.w500,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        );
//                      },
//                    ),
//                  ),
                  SizedBox(
                    height: rouletteHeight,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page - 1000;
                        });
                      },
                      itemBuilder: (BuildContext context, int pageIndex) {
                        final index = pageIndex - 1000;
                        final isCurrentPage = index == _currentPage;
                        final distance = (index - _page!).abs();
                        final rotation = asin(distance / 3);
                        final opacity =
                            1 / _mapToInterval(distance, 0, 3, 1, 4);
                        final sign = (index == _page)
                            ? 1.0
                            : (index - _page!) / (index - _page!).abs();

                        final hour = index % 24;
                        final hourStr = hour < 10 ? '0$hour' : '$hour';

                        return Container(
                          alignment: Alignment.center,
                          child: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4(
                              1.0,
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                              1.0,
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                              1.0,
                              -sign * rotation / 1000,
                              0.0,
                              0.0,
                              0.0,
                              1.0,
                            )..rotateY(rotation),
                            child: Opacity(
                              opacity: opacity,
                              child: Container(
                                alignment: Alignment.center,
//                                width: ScreenUtil().setWidth(77).toDouble(),
//                                padding: EdgeInsets.symmetric(
//                                  vertical:
//                                      ScreenUtil().setHeight(12).toDouble(),
////                                  horizontal:
////                                      ScreenUtil().setWidth(8).toDouble(),
//                                ),
                                child: Text(
                                  '$hourStr:00',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: isCurrentPage
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

  }
}
