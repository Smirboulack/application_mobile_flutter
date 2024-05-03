import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sevenapplication/core/services/settinngs_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class Potique extends StatefulWidget {
  @override
  _Potique_ConditionsState createState() => _Potique_ConditionsState();
}

class _Potique_ConditionsState extends State<Potique> {
  Settings_Services settings_inf = new Settings_Services();
  String text = "";

  get_politiques() async {
    var a = await settings_inf.get_politiques();
    setState(() {
      text = a["text"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_politiques();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: ColorsConst.col_app,
        centerTitle: true,
        title: new Text(
          'Politique de confidentialité',
        ),
      ),
      body: new SingleChildScrollView(
        child: new Container(
            padding: new EdgeInsets.all(8.0),
            child: text == ""
                ? CupertinoActivityIndicator()
                : Html(
                    data: text.toString().replaceAll(RegExp(r'(\\n)+'), ''),
                  )),
      ),
    );
  }
}
