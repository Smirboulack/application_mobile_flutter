import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:sevenapplication/core/services/settinngs_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class AboutUs extends StatefulWidget {
  @override
  _Potique_ConditionsState createState() => _Potique_ConditionsState();
}

class _Potique_ConditionsState extends State<AboutUs> {
  Settings_Services settings_inf = new Settings_Services();
  String text = "";

  get_aboutus() async {
    var a = await settings_inf.get_about();
    setState(() {
      text = a["text"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_aboutus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: ColorsConst.col_app,
        centerTitle: true,
        title: new Text(
          "A propos de nous",
        ),
      ),
      body: new SingleChildScrollView(
        child: new Container(
            padding: EdgeInsets.all(12.0),
            child: text == ""
                ? CupertinoActivityIndicator()
                : Html(data:
            text.toString().replaceAll(RegExp(r'(\\n)+'), ''),
            )),
      ),
    );
  }
}
