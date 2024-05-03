import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sevenapplication/core/models/entreprise.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/screens/worker/home_worker/worker_entreprise.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';
import 'package:sevenapplication/widgets/horizontal_options.dart';
import 'package:sevenapplication/widgets/profile_image_view.dart';
import 'package:sevenapplication/widgets/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  ParseUser? utilisateur;
  SettingsScreen({required this.utilisateur}) : super();

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAvailable = true;
  bool _notificationsEnabled = true;

  Future<void> Disconnect() async {
    await logoutUser();
    context.go('/connection');
  }

  void showmodal(BuildContext context) {
    Alert(
        context: context,
        title: "Déconnexion",
        desc: "Voulez-vous vraiment vous déconnecter de l'application ?",
        buttons: [
          DialogButton(
              color: ColorsConst.col_app,
              child: Text(
                "Confirmer",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                await Disconnect();
              })
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
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
                      'Paramètres',
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
                    InkWell(
                      onTap: () async {
                        _notificationsEnabled = false;
                      },
                      child: SettingsItem(
                        icon: SvgPicture.asset('assets/icons/bell.svg'),
                        text: 'Notifications',
                        hasSwitch: true,
                        isActive: _notificationsEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(16).toDouble()),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0.2,
                      color: ColorsConst.col_app_black,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(16).toDouble()),
                    InkWell(
                      onTap: () async {
                        context.goNamed("ProfilWorker",
                            extra: widget.utilisateur);
                      },
                      child: SettingsItem(
                        icon: SvgPicture.asset(
                            'assets/icons/account_parameters.svg'),
                        text: 'Profil',
                        hasArrow: false,
                        onChanged: (bool) {
                          print(bool);
                        },
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(16).toDouble()),
                    InkWell(
                      onTap: () async {
                        context.goNamed("WorkerEntreprise",
                            extra: widget.utilisateur);
                      },
                      child: SettingsItem(
                        icon: SvgPicture.asset('assets/icons/company.svg'),
                        text: 'Entreprise',
                        hasArrow: false,
                        onChanged: (bool) {
                          print(bool);
                        },
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(16).toDouble()),
                    InkWell(
                      onTap: () async {
                        context.goNamed('BankUser', extra: widget.utilisateur);
                      },
                      child: SettingsItem(
                        icon: SvgPicture.asset('assets/icons/wallet.svg'),
                        text: 'Informations bancaires',
                        hasArrow: false,
                        onChanged: (bool) {},
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(16).toDouble()),
                    InkWell(
                      onTap: () async {
                        showmodal(context);
                      },
                      child: SettingsItem(
                        icon: SvgPicture.asset('assets/icons/logout.svg'),
                        text: 'Déconnexion',
                        hasArrow: false,
                        onChanged: (bool) {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(20).toDouble()),
                child: HorizontalOptions(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
