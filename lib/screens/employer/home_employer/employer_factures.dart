import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/facture.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'package:sevenapplication/core/models/service.dart';
import 'package:sevenapplication/core/models/status.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/database/database.dart';
import 'package:sevenapplication/core/services/database/factures_services.dart';
import 'package:sevenapplication/widgets/cards/facture_card.dart';
import 'package:sevenapplication/widgets/custom_toggle_button.dart';
import 'package:sevenapplication/core/models/titles.dart';

class EmployerFactures extends StatefulWidget {
  ParseUser? utilisateur;

  EmployerFactures({super.key, this.utilisateur});

  @override
  State<EmployerFactures> createState() => _EmployerFacturesState();
}

class _EmployerFacturesState extends State<EmployerFactures> {
  int _currentIndex = 0;
  late List<Facture> factureList = [];
  bool load = true;

  Future<void> facturesinit() async {
    final factures = await FactureServices.getAllFactures();
    if (!this.mounted) return;
    setState(() {
      factureList = factures;
      load = false;
    });
  }

  void initState() {
    super.initState();
    facturesinit();
    //print("factureList: $factureList");
    //factureList = [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: load == true
          ? Center(child: CupertinoActivityIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                const SizedBox(height: 24),
                CustomToggleButton(
                  onTap: (int v) {
                    _currentIndex = v;
                    setState(() {});
                  },
                  label: const ["Tous", "Due(s)", "Réglée(s)"],
                  isFirst: _currentIndex,
                ),
                if (_currentIndex == 0) _appliedList(0),
                if (_currentIndex == 1) _appliedList(1),
                if (_currentIndex == 2) _appliedList(2),
              ],
            ),
    );
  }

  Column _appliedList(int type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        load == true
            ? Center(child: CupertinoActivityIndicator())
            : factureList.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/money_flower.svg",
                            height: ScreenUtil().setHeight(100),
                            width: ScreenUtil().setWidth(100),
                          ),
                          Text(
                            "Aucune facture",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    /* children: factureList.map((e) => FactureCard(e)).toList(), */
                    children: type == 0
                        ? factureList.map((e) => FactureCard(e)).toList()
                        : type == 1
                            ? factureList
                                .where((element) => element.status == "Due")
                                .map((e) => FactureCard(e))
                                .toList()
                            : factureList
                                .where((element) => element.status == "Réglée")
                                .map((e) => FactureCard(e))
                                .toList()),
        SizedBox(height: 16),
      ],
    );
  }
}
