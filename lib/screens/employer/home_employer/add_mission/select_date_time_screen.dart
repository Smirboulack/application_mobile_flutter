import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';
import 'package:sevenapplication/widgets/buttonWidget/custom_button.dart';
import 'package:sevenapplication/widgets/emp_calendar.dart';
import 'package:sevenapplication/widgets/emp_picker.dart';

class SelectDateTimeScreen extends StatefulWidget {
  SelectDateTimeScreen({Key? key}) : super(key: key);

  @override
  _SelectDateTimeScreenState createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime? _dateTimeFrom;
  DateTime? _dateTimeTo;
  DateTime? _currentDate;

  @override
  void initState() {
    super.initState();

    _currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConst.col_wite,
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(8).toDouble()),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(15).toDouble(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    BackButton(),
                    // SecBackButton(),
                    Text(
                      'DATE ET HEURE',
                      style: StylesApp.textStyleM,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(23).toDouble()),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Visibility(
                      visible: false,
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      child: Column(
                        children: <Widget>[
                          Text(
                            DateFormat('EEEE').format(DateTime.now()),
                          ),
                          SizedBox(
                              height: ScreenUtil().setHeight(3).toDouble()),
                          Text(
                            DateFormat('dd MMMM').format(DateTime.now()),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (_dateTimeFrom == null)
                                Text(
                                  'From',
                                  style: TextStyle(
                                    color: ColorsConst.col_app_f,
                                  ),
                                ),
                              if (_dateTimeFrom != null) ...[
                                Text(
                                  DateFormat('EEEE').format(_dateTimeFrom!),
                                  //style: theme.dateScreenDayStyle,
                                ),
                                SizedBox(
                                    height:
                                        ScreenUtil().setHeight(3).toDouble()),
                                Text(
                                  DateFormat('dd MMMM').format(_dateTimeFrom!),
                                  //style: theme.dateScreenDateStyle,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SvgPicture.asset('assets/icons/cal.svg'),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (_dateTimeTo == null)
                                Text(
                                  'To',
                                  style: TextStyle(
                                    color: ColorsConst.col_app_f,
                                  ),
                                ),
                              if (_dateTimeTo != null) ...[
                                Text(
                                  DateFormat('EEEE').format(_dateTimeTo!),
                                  //   style: theme.dateScreenDayStyle,
                                ),
                                SizedBox(
                                    height:
                                        ScreenUtil().setHeight(3).toDouble()),
                                Text(
                                  DateFormat('dd MMMM').format(_dateTimeTo!),
                                  //  style: theme.dateScreenDateStyle,
                                ),
                              ] //,
                            ], //
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              EmpCalendar(
                currentDate: _currentDate!,
                onDateChanged: (dateFrom, dateTo) {
                  setState(
                    () {
                      if (dateFrom == null) {
                        _dateTimeFrom = null;
                      } else if (_dateTimeFrom == null) {
                        _dateTimeFrom = dateFrom;
                      } else {
                        _dateTimeFrom = DateTime(
                            dateFrom.year,
                            dateFrom.month,
                            dateFrom.day,
                            _dateTimeFrom!.hour,
                            _dateTimeFrom!.minute);
                      }

                      if (dateTo == null) {
                        _dateTimeTo = null;
                      } else if (_dateTimeTo == null) {
                        _dateTimeTo = dateTo;
                      } else {
                        _dateTimeTo = DateTime(dateTo.year, dateTo.month,
                            dateTo.day, _dateTimeTo!.hour, _dateTimeTo!.minute);
                      }
                    },
                  );
                },
              ),
              Spacer(),
              EmpTimePicker(currentDate: _currentDate!),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(30).toDouble(),
                  ),
                  child: CustomButton(onPressed: () {
                    context.go('/addMissionLastPage');

                  }, buttonText: 'Suivant'),
                ),
              ),
              // disabledColor: ColorsConst.col_app_black,

              SizedBox(height: ScreenUtil().setHeight(23).toDouble()),
            ],
          ),
        ),
      ),
    );
  }
}
