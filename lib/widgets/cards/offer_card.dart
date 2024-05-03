import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: StylesApp.decoration,
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Center(child: Container()),
          ),
          const SizedBox(width: 12),
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jiya ATLAGH",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2c2c2c)),
              ),
              SizedBox(height: 4),
              Text(
                "Lyon, France",
                style: TextStyle(fontSize: 12, color: Color(0xff939393)),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.more_horiz_outlined),
        ],
      ),
    );
  }
}
