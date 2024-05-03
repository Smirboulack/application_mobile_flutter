import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';
import 'package:sevenapplication/widgets/buttonWidget/custom_button.dart';
import 'package:sevenapplication/widgets/checkboxWidget/custom_checkbox.dart';
import 'package:sevenapplication/widgets/inputWidget/custom_input.dart';
import 'package:sevenapplication/widgets/textWidgets/regular_text.dart';

class AddMissionLast extends StatefulWidget {
  AddMissionLast({Key? key}) : super(key: key);

  @override
  _AddMissionLastState createState() => _AddMissionLastState();
}

class _AddMissionLastState extends State<AddMissionLast> {
  int _employeeCount = 1;
  bool condition1 = false;
  bool condition2 = false;
  final desc = TextEditingController();

  void showmodal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 280.0,
            height: 250.0,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/smiley.svg",
                    /* width: 46.5,
                height: 46.5, */
                  ),
                  SizedBox(height: 11),
                  Text(
                    'Votre mission a été créée avec succès!',
                    style: TextStyle(
                      color: Color(0xFF5C5C5C),
                      fontSize: 16,
                      fontFamily: 'Istok Web',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 21),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Color(0xFF8CC63E),
                            onPrimary: Colors.white,
                            textStyle: const TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          onPressed: () {
                            //context.pop();
                            context.pushReplacement('/home_employer_page');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text("Accueil")
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      'AUTRES INFORMATIONS',
                      style: StylesApp.textStyleM,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(15.32).toDouble()),
              Container(
                //  width: 140.w,
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(12).toDouble(),
                ),
                padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(23).toDouble(),
                  right: ScreenUtil().setWidth(12).toDouble(),
                  bottom: ScreenUtil().setHeight(41).toDouble(),
                  left: ScreenUtil().setWidth(12).toDouble(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(51).toDouble()),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      decoration: StylesApp.decoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            "Nombre des employés : ",
                            style: StylesApp.textStyleM,
                          )),
                          InkWell(
                            onTap: () {
                              if (_employeeCount > 1) {
                                setState(() {
                                  _employeeCount -= 1;
                                });
                              }
                            },
                            child: SvgPicture.asset(
                              'assets/icons/rm.svg',
                              color: ColorsConst.col_app,
                              width: ScreenUtil().setWidth(32).toDouble(),
                              height: ScreenUtil().setWidth(32).toDouble(),
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(32).toDouble(),
                            height: ScreenUtil().setWidth(32).toDouble(),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _employeeCount.toString(),
                              style: StylesApp.textStyleM,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _employeeCount += 1;
                              });
                            },
                            child: SvgPicture.asset(
                              'assets/icons/Plus.svg',
                              color: ColorsConst.col_app,
                              width: ScreenUtil().setWidth(32).toDouble(),
                              height: ScreenUtil().setWidth(32).toDouble(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 20.h),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        decoration: StylesApp.decoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mobilité : ",
                              style: StylesApp.textStyleM,
                            ),
                            Row(
                              children: [
                                CustomCheckbox(
                                    value: condition1,
                                    onChanged: (value) {
                                      setState(() {
                                        condition1 = value;
                                      });
                                    }),
                                SizedBox(width: 20),
                                Flexible(
                                  child: RegularText(
                                    text:
                                        "La mission nécessite le permis de conduire",
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomCheckbox(
                                    value: condition2,
                                    onChanged: (value) {
                                      setState(() {
                                        condition2 = value;
                                      });
                                    }),
                                SizedBox(width: 20),
                                Flexible(
                                  child: RegularText(
                                    text:
                                        "Le professionnel devra utiliser son propre véhicule",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Container(
                      height: 20.h,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        decoration: StylesApp.decoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description de la mission : ",
                              style: StylesApp.textStyleM,
                            ),
                            Container(
                              height: 12.h,
                            ),
                            CustomInput(
                              hintText: 'Écrire ici la description',
                              myController: desc,
                              maxLines: 5,
                            )
                          ],
                        ))
                  ],
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(30).toDouble(),
                  ),
                  child: CustomButton(
                    buttonText: 'Publier la mission',
                    onPressed: () {
                      showmodal();
                      //context.pushReplacement('/home_employer_page');
                    },
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(23).toDouble()),
            ],
          ),
        ),
      ),
    );
  }
}
