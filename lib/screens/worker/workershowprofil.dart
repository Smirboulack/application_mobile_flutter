import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/services/database/rating_services.dart';

import '../../utils/colors_app.dart';
import '../../utils/styles.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/profile_image_view.dart';
import '../../widgets/settings_item.dart';

class WorkerShowProfil extends StatefulWidget {
  final ParseUser? utilisateur;

  const WorkerShowProfil({Key? key, this.utilisateur}) : super(key: key);

  @override
  State<WorkerShowProfil> createState() => _WorkerShowProfilState();
}

class _WorkerShowProfilState extends State<WorkerShowProfil> {
  XFile? imageactu;
  XFile? imagepreview;
  late double numrate = 0.0;
  Future<void> getrate() async {
    double _numrate =
        await RatingService().getRating(widget.utilisateur!.objectId!);
    setState(() {
      numrate = _numrate;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.utilisateur);
    getrate();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SafeArea(
            child: Column(children: <Widget>[
          SizedBox(height: ScreenUtil().setHeight(26).toDouble()),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackButton(),
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsetsDirectional.only(
                  end: ScreenUtil().setWidth(21).toDouble(),
                ),
                child: Text(
                  'Profil',
                  style: StylesApp.textStyleM,
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(15).toDouble()),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(8).toDouble(),
            ),
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(17).toDouble(),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(width: ScreenUtil().setWidth(36).toDouble()),
                ProfileImageView(utilisateur: widget.utilisateur!),
                SizedBox(width: ScreenUtil().setWidth(17).toDouble()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.utilisateur!.emailAddress.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "InterMedium",
                          color: ColorsConst.col_app_black),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(4).toDouble()),
                    Text(
                      'Membre depuis le ${widget.utilisateur!.createdAt!.day}/${widget.utilisateur!.createdAt!.month}/${widget.utilisateur!.createdAt!.year}',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: ScreenUtil().setSp(12).toDouble(),
                          fontFamily: "InterMedium",
                          color: ColorsConst.col_app_black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(31).toDouble()),
          Expanded(
            child: ListView(
              children: <Widget>[
                SettingsItem(
                  icon: SvgPicture.asset('assets/icons/user.svg'),
                  text: widget.utilisateur!.get('username'),
                  onChanged: (bool) {},
                ),
                SizedBox(height: ScreenUtil().setHeight(21).toDouble()),
                SettingsItem(
                  icon: SvgPicture.asset('assets/icons/call.svg'),
                  text: widget.utilisateur!.get('phoneNumber'),
                  onChanged: (bool) {},
                ),
                SizedBox(height: ScreenUtil().setHeight(30).toDouble()),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.2,
                  color: ColorsConst.col_app_black,
                ),
                SizedBox(height: ScreenUtil().setHeight(16).toDouble()),
                RatingBar.builder(
                  initialRating: numrate,
                  minRating: 0,
                  ignoreGestures: true,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ],
            ),
          ),
        ])),
      ),
    );
  }
}
