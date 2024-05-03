import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPopups {
  static void showmodal1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 320.0,
            height: 300.0,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/smiley.svg",
                  ),
                  SizedBox(height: 11),
                  Text(
                    'Ajout de mission réussi',
                    style: TextStyle(
                      color: Color(0xFF5C5C5C),
                      fontSize: 16,
                      fontFamily: 'Istok Web',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 21),
                  Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Color(0xFF8CC63E),
                            onPrimary: Colors.white,
                            textStyle: TextStyle(
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Voir mes missions"),
                          ),

                      ),
                      SizedBox(width: 20),
                       ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Color(0xFF8CC63E),
                            onPrimary: Colors.white,
                            textStyle: TextStyle(
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Ajouter une autre mission"),
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
  }
}
