// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/buttonWidget/primary_button.dart';
import 'package:sevenapplication/widgets/textWidgets/large_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    svgWidget(String im) => SvgPicture.asset("assets/icons/$im");
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.only(left: screenSize.width - 50, top: 5),
            /* child: SvgPicture.asset(
              'assets/icons/global.svg',
              width: 32,
              height: 32,
              color: Colors.black,
            ),*/
          ),
          Center(
            child: Hero(
              tag: "logo",
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorsConst.col_app,
                    width: 10,
                  ),
                  /*boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 102, 102, 102),
                      blurRadius: 2,
                      offset: Offset(4, 5),
                    ),
                  ],*/
                ),
                child: CircleAvatar(
                  radius: 80.w,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 70.w,
                    child: Padding(
                        padding: EdgeInsets.all(17),
                        child: Image.asset("assets/images/jobs3.png")),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          LargeText(
            text: "SEVEN JOBS",
            textColor: ColorsConst.col_app,
            textSize: screenSize.width / 10,
          ),
          SizedBox(
            height: 17,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Trouver des missions adaptées à votre potentiel et votre passion",
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: screenSize.width / 20,
                    fontFamily: "InterBold"),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Spacer(),
          Column(
            children: [
              Text(
                "Déjà un compte ?",
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: screenSize.width / 25,
                    fontFamily: "InterBold"),
              ),
              Container(
                height: 6.h,
              ),
              Container(
                  width: 320.w,
                  child: PrimaryButton(
                    onTap: () {
                      context.pushReplacement('/connection');
                    },
                    icon: "",
                    disabledColor: ColorsConst.borderColor,
                    fonsize: 19.0,
                    prefix: Container(),
                    color: ColorsConst.col_app,
                    isLoading: false,
                    text: "Connexion",
                    textStyle: TextStyle(fontFamily: "InterBold"),
                  )),
              /*  SizedBox(
                width: screenSize.width / 1.4,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushReplacement('/connection');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: ColorsConst.col_app,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Connexion",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              Text(
                "Pas encore de compte ?",
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: screenSize.width / 25,
                    fontFamily: "InterBold"),
              ),
              Container(
                height: 6.h,
              ),
              Container(
                  width: 320.w,
                  child: PrimaryButton(
                    onTap: () {
                      context.pushReplacement('/register');
                    },
                    icon: "",
                    disabledColor: ColorsConst.borderColor,
                    fonsize: 19.0,
                    prefix: Container(),
                    color: ColorsConst.col_app,
                    isLoading: false,
                    text: "Inscription",
                    textStyle: TextStyle(fontFamily: "InterBold"),
                  )),
              /* SizedBox(
                width: screenSize.width / 1.4,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushReplacement('/register');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: ColorsConst.col_app,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Inscription",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
          SizedBox(
            height: 36.h,
          ),
        ],
      ),
    );
  }
}
