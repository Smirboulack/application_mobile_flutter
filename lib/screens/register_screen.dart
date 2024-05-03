import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sevenapplication/utils/const_app.dart';
import 'package:sevenapplication/widgets/header_widget.dart';
import 'package:sevenapplication/widgets/footer_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              HeaderWidget(),
              Container(height: 42.h,),
              Container(
                child: Text(
                  'Je suis',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.bold,
                    fontFamily: ConstApp.fontfamily,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: GestureDetector(
                  onTap: () => context.go('/worker'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.02,
                        vertical: screenSize.height * 0.02),
                    child: Row(
                      children: [
                        Text(
                          'Un Jobber',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/images/Jober.png",
                            width: screenSize.width * 0.2),
                        SizedBox(width: screenSize.width * 0.02),
                        Icon(Icons.arrow_forward_sharp),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: GestureDetector(
                  onTap: () => context.go('/employer'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.02,
                        vertical: screenSize.height * 0.02),
                    child: Row(
                      children: [
                        Text(
                          'Un Boss',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/images/Boss.png",
                            width: screenSize.width * 0.2),
                        SizedBox(width: screenSize.width * 0.02),
                        Icon(Icons.arrow_forward_sharp),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              TextButton(
                  onPressed: () {
                    context.go('/connection');
                  },
                  child: Text("Déjà inscrit ? Connectez-vous")),
            ],
          )),
          FooterWidget(),
        ],
      ),
    );
  }
}
