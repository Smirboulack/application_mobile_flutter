import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/core/models/metier.dart';
import 'package:sevenapplication/core/services/database/metiers_services.dart';
import 'package:sevenapplication/screens/employer/home_employer/components/titles_list.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/buttonWidget/custom_button.dart';

class MetiesList extends StatefulWidget {
  @override
  State<MetiesList> createState() => _MetiesListState();
}

class _MetiesListState extends State<MetiesList> {
  Metier? metier;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool load = true;
  SearchBar? searchBar;
  final TextEditingController _searchQuery = TextEditingController();
  bool _IsSearching = false;
  String _searchText = "";
  List<Metier> metiersList = [];

  getListMeties() async {
    var b = await ServicesRepository.fetchServicesWithTitles();
    if (!this.mounted) return;
    setState(() {
      metiersList = List<Metier>.from(b);
      load = false;
    });
  }

  _MetiesListState() {
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

  sete(Metier ent) {
    metier = ent;
  }

  func() {
    for (Metier i in metiersList) {
      setState(() {
        i.check = false;
      });
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getListMeties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 12),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 120.w,
                  child: CustomButton(
                    onPressed: () async {
                      if (metier == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veuillez choisir un metier !'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TitlesList(metier!),
                          ),
                        );
                      }
                    },
                    buttonText: "Suivant",
                  ))
            ]),
      ),
      appBar: AppBar(
        elevation: 1.0,
        iconTheme: const IconThemeData(color: ColorsConst.col_app_black),
        backgroundColor: Colors.white,
        title: const Text(
          "Métiers",
          style: TextStyle(color: ColorsConst.col_app_black),
        ),
        actions: <Widget>[],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Column(children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: TextField(
                controller: _searchQuery,
                decoration: InputDecoration(
                    counterStyle: TextStyle(color: ColorsConst.col_app),
                    isDense: true,
                    contentPadding: EdgeInsets.only(left: 20.0, right: 16),
                    hintText: 'Rechercher un métier',
                    enabledBorder: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(
                          color: ColorsConst.col_app, width: 0.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintStyle: TextStyle(color: ColorsConst.col_app),
                    suffixIcon: const Padding(
                      padding:
                          EdgeInsetsDirectional.only(start: 12.0, end: 12.0),
                      child: Icon(
                        Icons.search,
                        color: ColorsConst.col_app,
                        size: 30.0,
                      ), // icon is 48px widget.
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorsConst.col_app, width: 0.0),
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    filled: true),
              ),
            ),
          ]),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(4),
        children: load
            ? [const Center(child: CupertinoActivityIndicator())]
            : metiersList
                .map((val) => MetierCard(val, func, _searchText, sete))
                .toList(),
      ),
    );
  }
}

class MetierCard extends StatefulWidget {
  MetierCard(this.metier, this.funcall, this.searchText, this.func);

  Metier metier;
  var funcall;
  var searchText;
  var func;

  @override
  _MetierCard_cardState createState() => _MetierCard_cardState();
}

class _MetierCard_cardState extends State<MetierCard> {
  Metier? st;

  var load = true;

  submit() {
    if (widget.metier.check == true) {
      setState(() {
        widget.metier.check = false;
        st = null;
        widget.func(null);
      });
    } else {
      widget.funcall();
      setState(() {
        widget.metier.check = true;
        st = widget.metier;
        widget.func(st);
      });
    }
  }

  checkk() => IconButton(
        padding: EdgeInsets.all(0.0),
        splashColor: ColorsConst.col_app,
        onPressed: () {
          //widget.func();

          submit();
        },
        icon: new Container(
          margin: new EdgeInsets.only(left: 8.0, right: 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                // height: 70.0,
                //width: 70.0,
                child: new Icon(
                  Icons.check,
                  size: 20.0,
                  color: widget.metier.check == true
                      ? ColorsConst.col_app
                      : ColorsConst.col_app_f,
                ),
                decoration: new BoxDecoration(
                  color: widget.metier.check == true
                      ? Colors.grey[100]
                      : Colors.grey[100],
                  border: new Border.all(
                      width: 1.5,
                      color: widget.metier.check == true
                          ? ColorsConst.col_app
                          : ColorsConst.col_app_f),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(8.0)),
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return (!widget.metier.name
                .toLowerCase()
                .contains(widget.searchText.toLowerCase()) &&
            widget.searchText.isNotEmpty)
        ? new Container()
        : InkWell(
            onTap: () {
              submit();
            },
            child: Container(
              child: ListTile(
                  title: Text(
                    widget.metier.name.toString().toUpperCase(),
                    maxLines: 1,
                    style: TextStyle(
                        color: widget.metier.check == true
                            ? ColorsConst.col_app_f
                            : ColorsConst.col_app_black,
                        fontWeight: widget.metier.check == true
                            ? FontWeight.w800
                            : FontWeight.w500,
                        fontSize: 14,
                        height: 1.2),
                  ),
                  trailing: checkk()),
            ),
          );
  }
}
