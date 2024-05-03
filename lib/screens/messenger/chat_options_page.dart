import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class ChatOptionsPage extends StatelessWidget {
  ChatOptionsPage(this.user, this.user_me, this.returnn, this.delete_messages,
      {Key? key})
      : super(key: key);

  User user;
  User user_me;
  Function? returnn;
  Function delete_messages;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.8, sigmaY: 1.8),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
          ),
          //  color: ColorsConst.col_app_black2.withOpacity(0.76)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(height: 82.h),
              Container(
                  child: CircleAvatar(
                      radius: 46.r,
                      backgroundImage:
                          CachedNetworkImageProvider(user.image!))),
              Container(height: 12.h),
              Center(
                  child: Text(
                user.username,
                //  style: AppTextStyles.style_white2_bold22,
              )),
              Container(height: 100.h),
              Center(
                  child: Container(
                      padding: new EdgeInsets.all(12.0),
                      child: Row(
                        children: [],
                      ))),
              Container(height: 36.0),
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.4],
                          colors: [ColorsConst.col_app, ColorsConst.col_app_f]),
                      borderRadius: BorderRadius.all(Radius.circular(80.0))),

                  //  color: Colors.white,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(1),
                    ),
                  child: Text( "Voir le profil"),
                    onPressed: () {
                      returnn!();

                      ///Here go to user Profile

                    },
                  )),
              Container(height: 12.h),
              Container(height: 12.h),
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.4],
                          colors: [ColorsConst.col_app, ColorsConst.col_app]),
                      borderRadius: BorderRadius.all(Radius.circular(80.0))),

                  //  color: Colors.white,
                  child:    ElevatedButton(
                    child: Text("Effacer l'historique"),
                    style: ButtonStyle(),

                    onPressed: () {
                      returnn!();
                      delete_messages();
                    },
                  )),
              Expanded(child: Container()),
              InkWell(
                  onTap: () {
                    returnn!();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Text("RETOUR",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold)),
                  )),
              Container(height: 60.0.sp),
            ],
          )),
    ));
  }
}
