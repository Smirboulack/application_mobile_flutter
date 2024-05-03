import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class ProfileImageView extends StatefulWidget {
  ParseUser? utilisateur;
  ProfileImageView({
    Key? key,
    required this.utilisateur,
  }) : super(key: key);
  @override
  State<ProfileImageView> createState() => _ProfileImageViewState();
}

class _ProfileImageViewState extends State<ProfileImageView> {
  File? image;
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorsConst.col_app,
              width: 10,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 102, 102, 102),
                blurRadius: 2,
                offset: Offset(4, 5),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              if (widget.utilisateur!.get('type') == 'Boss') {
                context.goNamed('ProfilEmployer', extra: widget.utilisateur);
              } else if (widget.utilisateur!.get('type') == 'Jober') {
                context.goNamed('ProfilWorker', extra: widget.utilisateur);
              }
            },
            child: CircleAvatar(
              radius: screenSize.width / 7,
              backgroundColor: Colors.white,
              child: widget.utilisateur?.get('Avatar') == null
                  ? SvgPicture.asset("assets/icons/profil_holder.svg",
                      width: screenSize.width * 0.1,
                      height: screenSize.height * 0.5)
                  : CircleAvatar(
                      radius: screenSize.width / 5,
                      backgroundImage:
                          NetworkImage(widget.utilisateur!.get('Avatar').url)),
            ),
          ),
        ),
        /* Positioned(
          right: -4,
          bottom: -4,
          child: ElevatedButton(
            onPressed: () {
              showDialogPickImageOrCameraImage();
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              primary: const Color.fromARGB(255, 204, 204, 204),
              fixedSize: Size(screenSize.width * 0.1, screenSize.width * 0.1),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/Cameraa.svg',
                width: screenSize.width * 0.05,
                height: screenSize.width * 0.05,
              ),
            ),
          ),
        ), */
      ],
    );
  }
}
