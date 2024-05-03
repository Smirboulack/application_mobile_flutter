import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HorizontalOptions extends StatelessWidget {
  const HorizontalOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    svgWidget(String im) => SvgPicture.asset("assets/icons/$im");

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            const emailUrl = 'mailto:contact@sevenjobs.fr';
            launchUrl(Uri.parse(emailUrl));
          },
          child: svgWidget("email.svg"),
        ),
        SizedBox(width: 26.w),
        InkWell(
          onTap: () {
            const instagramUrl = 'https://www.instagram.com/seven7jobs/?hl=fr';
            launchUrl(Uri.parse(instagramUrl));
          },
          child: svgWidget("insta.svg"),
        ),
        SizedBox(width: 26.w),
        InkWell(
          onTap: () {
            // Action à réaliser pour le troisième bouton (lien)
          },
          child: svgWidget("link.svg"),
        ),
        SizedBox(width: 26.w),
        InkWell(
          onTap: () {
            // Action à réaliser pour le quatrième bouton (Facebook)
          },
          child: svgWidget("facebook.svg"),
        ),
      ],
    );
  }
}