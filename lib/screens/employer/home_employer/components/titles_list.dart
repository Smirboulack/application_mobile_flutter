import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/core/models/metier.dart';
import 'package:sevenapplication/core/models/titles.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/buttonWidget/custom_button.dart';

class TitlesList extends StatefulWidget {
  TitlesList(this.metier);

  Metier metier;

  @override
  State<TitlesList> createState() => _TitlesListlistState();
}

class _TitlesListlistState extends State<TitlesList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool load = true;
  SearchBar? searchBar;
  final TextEditingController _searchQuery = TextEditingController();
  bool? _IsSearching;
  String _searchText = "";
  TitleMetier? selectedTitles;

  _TitlesListlistState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  sete(TitleMetier ent) {
    selectedTitles = ent;
  }

  func() {
    for (TitleMetier i in widget.metier.titles) {
      setState(() {
        i.check = false;
      });
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 120.w,
                  child: CustomButton(
                    onPressed: () async {
                      List<TitleMetier> selectTitle = [];
                      for (TitleMetier i in widget.metier.titles) {
                        if (i.check == true) {
                          selectTitle.add(i);
                        }
                      }

                      Navigator.pop(
                          context, [widget.metier, selectTitle.first]);
                      Navigator.pop(
                          context, [widget.metier, selectTitle.first]);
                    },
                    buttonText: "Choisir",
                  ))
            ]),
      ),
      appBar: AppBar(
        elevation: 1.0,
        iconTheme: IconThemeData(color: ColorsConst.col_app_f),
        backgroundColor: Colors.white,
        title: Text(
          "Fonctions",
          style: TextStyle(color: ColorsConst.col_app_f),
        ),
        actions: <Widget>[],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: TextField(
                    controller: _searchQuery,
                    decoration: InputDecoration(
                        counterStyle: TextStyle(color: ColorsConst.col_app),
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 20.0, right: 16),
                        hintText: 'Rechercher une fonction',
                        enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: BorderSide(
                              color: ColorsConst.col_app, width: 0.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintStyle: TextStyle(color: ColorsConst.col_app),
                        suffixIcon: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 12.0, end: 12.0),
                          child: Icon(
                            Icons.search,
                            color: ColorsConst.col_app,
                            size: 30.0,
                          ), // icon is 48px widget.
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorsConst.col_app, width: 0.0),
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        filled: true),
                  ),
                ),
              ],
            )),
      ),
      body: ListView(
        padding: EdgeInsets.all(4),
        children: widget.metier.titles
            .map((val) => Pays_card(val, func, _searchText, sete))
            .toList(),
      ),
    );
  }
}

class Pays_card extends StatefulWidget {
  Pays_card(this.title, this.funcall, this.searchText, this.func);

  TitleMetier title;
  var funcall;
  var searchText;
  var func;

  @override
  Pays_card_cardState createState() => Pays_card_cardState();
}

class Pays_card_cardState extends State<Pays_card> {
  TitleMetier? titleS;

  var load = true;

  submit() {
    //

    if (widget.title.check == true) {
      setState(() {
        widget.title.check = false;
        titleS = null;
        //widget.func(titleS);
        widget.funcall();
      });
    } else {
      // widget.funcall();
      setState(() {
        widget.funcall();
        widget.title.check = true;

        titleS = widget.title;
        widget.func(titleS);
      });
      //  widget.list.add(widget.com);
    }
  }

  checkk() => IconButton(
        padding: EdgeInsets.all(0.0),
        splashColor: ColorsConst.col_app,
        onPressed: () {
          //widget.func();

          submit();
        },
        icon: Container(
          margin: EdgeInsets.only(left: 8.0, right: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                // height: 70.0,
                //width: 70.0,
                child: Icon(
                  Icons.check,
                  size: 20.0,
                  color: widget.title.check == true
                      ? ColorsConst.col_app
                      : ColorsConst.col_app_black,
                ),
                decoration: BoxDecoration(
                  color: widget.title.check == true
                      ? Colors.grey[100]
                      : Colors.grey[100],
                  border: Border.all(
                      width: 1.5,
                      color: widget.title.check == true
                          ? ColorsConst.col_app
                          : ColorsConst.col_app_black),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return (!widget.title.name
                .toString()
                .toLowerCase()
                .contains(widget.searchText.toLowerCase()) &&
            widget.searchText.isNotEmpty)
        ? Container()
        : InkWell(
            onTap: () {
              submit();
            },
            child: Container(
              child: ListTile(
                  title: Text(
                    widget.title.name.toString().toUpperCase(),
                    maxLines: 1,
                    style: TextStyle(
                        color: widget.title.check == true
                            ? ColorsConst.col_app_f
                            : ColorsConst.col_app_black,
                        fontWeight: widget.title.check == true
                            ? FontWeight.w800
                            : FontWeight.w500,
                        fontSize: 14,
                        height: 1.2),
                  ),
                  trailing: checkk()),
            ));
  }
}
