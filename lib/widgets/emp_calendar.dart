import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class EmpCalendar extends StatefulWidget {
  final DateTime currentDate;
  final void Function(DateTime dateFrom, DateTime dateTo) onDateChanged;

  EmpCalendar(
      {Key? key, required this.currentDate, required this.onDateChanged})
      : super(key: key);

  @override
  _EmpCalendarState createState() => _EmpCalendarState();
}

class _EmpCalendarState extends State<EmpCalendar> {
  DateTime? _currentViewedDate;

  @override
  void initState() {
    super.initState();

    _currentViewedDate = widget.currentDate;
  }

  double _calculateCalendarDaysHeight(TextDirection textDirection) {
    final dayTextSpan = TextSpan(
      text: 'A',
      // style: theme.calenderSelectedDayStyle,
    );
    final dayTextPainter = TextPainter(
      textDirection: textDirection,
      text: dayTextSpan,
    );
    dayTextPainter.layout();
    final dayHeight = dayTextPainter.height;

    return ((dayHeight + ScreenUtil().setHeight(10 * 2)) * 5) +
        (ScreenUtil().setHeight(5).toDouble() * 4);
  }

  @override
  Widget build(BuildContext context) {
    final calendarDaysHeight =
        _calculateCalendarDaysHeight(Directionality.of(context));

    return Container(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),
//          margin: EdgeInsets.symmetric(
//            horizontal: ScreenUtil().setWidth(3).toDouble(),
//          ),
      child: Column(
        children: <Widget>[
          _MonthYearButton(currentDate: _currentViewedDate!),
          SizedBox(height: ScreenUtil().setHeight(31).toDouble()),
          _WeekDays(),
          SizedBox(height: ScreenUtil().setHeight(29 - 11).toDouble()),
          SizedBox(
            height: calendarDaysHeight,
            child: _CalendarDays(
              currentDate: widget.currentDate,
              onDateChanged: (dateFrom, dateTo) {
                if (widget.onDateChanged != null) {
                  widget.onDateChanged(dateFrom, dateTo);
                }
              },
              onMonthChanged: (DateTime date) {
                setState(() {
                  _currentViewedDate = date;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthYearButton extends StatelessWidget {
  final DateTime currentDate;
  final List<String> _monthsShort = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  _MonthYearButton({required this.currentDate});

  @override
  Widget build(BuildContext context) {
    final currentMonthShort = _monthsShort[currentDate.month - 1];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        SizedBox(width: ScreenUtil().setWidth(20).toDouble()),
        Text(
          '$currentMonthShort - ${intl.DateFormat('yyyy').format(currentDate)}',
          style: const TextStyle(
            fontFeatures: [
              FontFeature.tabularFigures(),
            ],
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(20).toDouble()),

      ],
    );
  }
}

class _WeekDays extends StatelessWidget {
  final List<String> _weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          for (var weekDay in _weekDays)
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  weekDay,
                  //  style: theme.calendarWeekDayStyle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CalendarDays extends StatefulWidget {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final DateTime currentDate;
  final void Function(DateTime dateFrom, DateTime dateTo) onDateChanged;
  final void Function(DateTime date) onMonthChanged;

  _CalendarDays(
      {Key? key,
      required this.currentDate,
      this.dateFrom,
      this.dateTo,
      required this.onDateChanged,
      required this.onMonthChanged})
      : super(key: key);

  @override
  __CalendarDaysState createState() => __CalendarDaysState();
}

class __CalendarDaysState extends State<_CalendarDays> {
  DateTime? _dateFrom;
  DateTime? _dateTo;
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();

    _dateFrom = widget.dateFrom;
    _dateTo = widget.dateTo;
    _startDate = DateTime(widget.currentDate.year, widget.currentDate.month, 1);
  }

  DateTime _calculateCurrentDate(DateTime currentDate, int monthOffset) {
    final currentMonth = currentDate.month;
    if (currentMonth == 12 && monthOffset > 0) {
      return DateTime(currentDate.year + 1, 1, 1);
    } else if (currentMonth == 1 && monthOffset < 0) {
      return DateTime(currentDate.year - 1, 12, 1);
    }

    return DateTime(currentDate.year, currentDate.month + monthOffset, 1);
  }

  List<DateTime> _getMonthDays(DateTime currentDate) {
    final year = currentDate.year;
    final month = currentDate.month;
    var daysCount = 0;

    final daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    if (currentDate.month == DateTime.february) {
      final isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) {
        daysCount = 29;
      } else {
        daysCount = 28;
      }
    } else {
      daysCount = daysInMonth[month - 1];
    }

    return List<DateTime>.generate(
        daysCount, (int n) => DateTime(year, month, n + 1));
  }

  List<DateTime> _getDays(DateTime currentDate) {
    final lastMonth = _calculateCurrentDate(currentDate, -1);
    final nextMonth = _calculateCurrentDate(currentDate, 1);
    final currentMonthDays = _getMonthDays(currentDate);
    final lastMonthDays = _getMonthDays(lastMonth);
    final nextMonthDays = _getMonthDays(nextMonth);

    final firstDay = currentMonthDays.first;
    final lastDay = currentMonthDays.last;
    final sundayToFirstDay = firstDay.weekday % 7;
    final lastDayToSunday = 7 - lastDay.weekday;

    final daysFromLastMonth =
        lastMonthDays.sublist(lastMonthDays.length - sundayToFirstDay);
    final daysFromNextMonth = nextMonthDays.sublist(0, lastDayToSunday);

    return daysFromLastMonth + currentMonthDays + daysFromNextMonth;
  }

  @override
  Widget build(BuildContext context) {
    final dayTextSpan = TextSpan(
      text: 'A',
      // style: theme.calenderSelectedDayStyle,
    );
    final dayTextPainter = TextPainter(
      textDirection: Directionality.of(context),
      text: dayTextSpan,
    );
    dayTextPainter.layout();
    final dayHeight =
        dayTextPainter.height + ScreenUtil().setHeight(10 * 2).toDouble();

    return Container(
      child: PageView.builder(
        onPageChanged: (int page) {
          if (widget.onMonthChanged != null) {
            final startDate = _calculateCurrentDate(_startDate!, page);
            widget.onMonthChanged(startDate);
          }
        },
        itemBuilder: (BuildContext context, int pageIndex) {
          final startDate = _calculateCurrentDate(_startDate!, pageIndex);
          final days = _getDays(startDate);

          return Column(
            children: <Widget>[
              for (var i = 0; i < 5; i++)
                Builder(
                  builder: (
                    context,
                  ) {
                    var beforeRangeLength = 0;
                    if (_dateFrom == null) {
                      beforeRangeLength = 7;
                    } else {
                      for (var k = 0; k < 7; k++) {
                        final day = days[(i * 7) + k];
                        if (day.isBefore(_dateFrom!)) {
                          beforeRangeLength += 1;
                        } else {
                          break;
                        }
                      }
                    }

                    var rangeLength = 0;
                    if (_dateFrom != null && _dateTo != null) {
                      for (var k = beforeRangeLength; k < 7; k++) {
                        final day = days[(i * 7) + k];
                        if (day.isAtSameMomentAs(_dateFrom!) ||
                            day.isAtSameMomentAs(_dateTo!) ||
                            (day.isAfter(_dateFrom!) &&
                                day.isBefore(_dateTo!))) {
                          rangeLength += 1;
                        } else {
                          break;
                        }
                      }
                    }

                    return Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          for (var j = 0; j < 7; j++)
                            Builder(
                              builder: (context) {
                                final day = days[(i * 7) + j];

                                final isInRange = j >= beforeRangeLength &&
                                    j < (beforeRangeLength + rangeLength);

                                final isFirstInRange = j == beforeRangeLength;
                                final isLastInRange =
                                    j == (beforeRangeLength + rangeLength - 1);

                                final isSelected =
                                    day == _dateFrom || day == _dateTo;

                                final isInCurrentMonth =
                                    day.month == startDate.month;

                                var borderRadius = BorderRadius.circular(0);
//                                    if (j == 0) {
//                                      borderRadius = BorderRadius.only(
//                                        topLeft: Radius.circular(ScreenUtil()
//                                            .setHeight(dayHeight)
//                                            .toDouble()),
//                                        bottomLeft: Radius.circular(ScreenUtil()
//                                            .setHeight(dayHeight)
//                                            .toDouble()),
//                                      );
//                                    } else if (j == 6) {
//                                      borderRadius = BorderRadius.only(
//                                        topRight: Radius.circular(ScreenUtil()
//                                            .setHeight(dayHeight)
//                                            .toDouble()),
//                                        bottomRight: Radius.circular(
//                                            ScreenUtil()
//                                                .setHeight(dayHeight)
//                                                .toDouble()),
//                                      );
//                                    }

                                return Expanded(
                                  flex: 1,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      if (isInRange)
                                        Row(
                                          children: <Widget>[
                                            if (day
                                                .isAtSameMomentAs(_dateFrom!))
                                              Expanded(
                                                child: Container(),
                                              ),
                                            Expanded(
                                              child: Container(
                                                height: dayHeight,
                                                decoration: BoxDecoration(
                                                  color: ColorsConst.col_app,
                                                  borderRadius: borderRadius,
                                                ),
                                              ),
                                            ),
                                            if (day.isAtSameMomentAs(_dateTo!))
                                              Expanded(
                                                child: Container(),
                                              ),
                                          ],
                                        ),
                                      InkWell(
                                        onTap: () {
                                          /* Scaffold.of(context)
                                                  .removeCurrentSnackBar();*/

                                          if (_dateFrom == null &&
                                              _dateTo == null) {
                                            setState(() {
                                              _dateFrom = day;
                                            });
                                          } else if (_dateFrom != null &&
                                              _dateTo == null) {
                                            setState(() {
                                              if (day.isBefore(_dateFrom!) ||
                                                  day.isAtSameMomentAs(
                                                      _dateFrom!)) {
                                                /* Scaffold.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Please select a date superior to the start date.',
                                                        ),
                                                        backgroundColor:
                                                        Colors.red,
                                                      ),
                                                    );*/
                                              } else {
                                                _dateTo = day;
                                              }
                                            });
                                          } else {
                                            setState(() {
                                              _dateFrom = day;
                                              _dateTo = null;
                                            });
                                          }

                                          if (widget.onDateChanged != null) {
                                            widget.onDateChanged(
                                                _dateFrom!, _dateTo!);
                                          }
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: dayHeight,
                                          height: dayHeight,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? ColorsConst.col_app
                                                : Colors.transparent,
                                          ),
                                          child: Text(
                                            day.day.toString(),
                                            /* style: isSelected
                                                    ? theme
                                                    .calenderSelectedDayStyle
                                                    : isInCurrentMonth || isInRange
                                                    ? theme
                                                    .calendarEnabledDayStyle
                                                    : theme
                                                    .calendarDisabledDayStyle,*/
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
