import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:sevenapplication/screens/user_settings_screen.dart';
import 'package:sevenapplication/screens/worker/home_worker/fisrt_home_worker.dart';
import 'package:sevenapplication/screens/worker/home_worker/my_missions.dart';
import 'package:sevenapplication/screens/worker/home_worker/offers_all.dart';
import 'package:sevenapplication/screens/worker/home_worker/worker_drawersettings.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/const_app.dart';
import 'package:sevenapplication/utils/images.dart';
import 'package:sevenapplication/widgets/custom_navbar.dart';

class HomePageWorker extends StatefulWidget {
  ParseUser? utilisateur;
  HomePageWorker({Key? key, required this.utilisateur}) : super(key: key);

  @override
  State<HomePageWorker> createState() => _HomePageWorkerState();
}

class _HomePageWorkerState extends State<HomePageWorker> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  List<Widget> screens = [];

  Future<void> screensinit() async {
    setState(() {
      screens = [
        HomeFirstWorker(utilisateur: widget.utilisateur),
        AllOffers(utilisateur: widget.utilisateur),
        MyMissions(utilisateur: widget.utilisateur),
        UserSettingsScreen(utilisateur: widget.utilisateur),
      ];
    });
  }

  @override
  void initState() {
    screensinit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsScreen(utilisateur: widget.utilisateur),
      key: _key,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /* Image.asset("assets/images/jobs.png", width: 36.w), */
              Text(
                ConstApp.appName,
                style: TextStyle(
                  color: ColorsConst.col_app_black,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 6, bottom: 6, right: 8),
                child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: ColorsConst.col_app_f.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Center(
                              child: SvgPicture.asset(
                            AppImages.user,
                            color: ColorsConst.col_app_black,
                          )),
                        )))),
          ],
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, top: 6, bottom: 6, right: 8),
            child: GestureDetector(
              onTap: () {
                _key.currentState!.openDrawer();
              },
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: ColorsConst.col_app_f.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                    child: SvgPicture.asset(
                  AppImages.menu,
                  color: ColorsConst.col_app_black,
                )),
              ),
            ),
          )),
      body: screens[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        items: [
          {"name": "Accueil", "icon": AppImages.home},
          {"name": "Offres", "icon": AppImages.offer},
          {"name": "Mes missions", "icon": AppImages.missions},
          {"name": "Paramètres", "icon": AppImages.params}
        ],
        height: 62.h,
        currentIndex: _currentIndex,
        onItemSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
