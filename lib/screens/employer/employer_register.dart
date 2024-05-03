// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevenapplication/widgets/checkboxWidget/custom_checkbox.dart';
import 'package:sevenapplication/widgets/textWidgets/regular_text.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/footer_widget.dart';
import 'package:sevenapplication/widgets/header_widget.dart';

import 'package:sevenapplication/widgets/buttonWidget/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployerRegister extends StatefulWidget {
  const EmployerRegister({Key? key}) : super(key: key);

  @override
  State<EmployerRegister> createState() => _EmployerRegisterState();
}

class _EmployerRegisterState extends State<EmployerRegister> {
  bool condition1 = false;
  bool condition2 = false;
  bool condition3 = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderWidget(),
              SizedBox(height: 58.h),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avant d\'inscrire mon entreprise',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Column(
                      children: [
                        Row(
                          children: [
                            CustomCheckbox(
                              value: condition1,
                              onChanged: (value) {
                                setState(() {
                                  condition1 = value;
                                });
                              },
                            ),
                            SizedBox(width: screenSize.width * 0.05),
                            Flexible(
                              child: RegularText(
                                text:
                                    'J\'accepte les conditions générales d\'utilisation',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            CustomCheckbox(
                              value: condition2,
                              onChanged: (value) {
                                setState(() {
                                  condition2 = value;
                                });
                              },
                            ),
                            SizedBox(width: screenSize.width * 0.05),
                            Flexible(
                              child: RegularText(
                                text:
                                    'J\'accepte la politique de confidentialité',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          children: [
                            CustomCheckbox(
                              value: condition3,
                              onChanged: (value) {
                                setState(() {
                                  condition3 = value;
                                });
                              },
                            ),
                            SizedBox(width: screenSize.width * 0.05),
                            Flexible(
                              child: RegularText(
                                text:
                                    'Je ne souhaite pas être contacté par SMS ou email par les partenaires de SEVEN JOBS',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          '* Vous devez accepter les conditions générales d\'utilisation et la politique de confidentialité pour continuer',
                          style: TextStyle(
                            color: Colors.red[300],
                            fontSize: screenSize.width * 0.03,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.1),
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/register');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey[800],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                        child: Text('Annuler'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.1),
                      child: CustomButton(
                        buttonText: "Continuer",
                        onPressed: () {
                          if (condition1 && condition2) {
                            context.go('/information_employer');
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                    'Vous devez accepter les 2 premières conditions pour continuer',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                            color: ColorsConst.col_app),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          FooterWidget(),
        ],
      ),
    );
  }
}
