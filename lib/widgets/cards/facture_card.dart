import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sevenapplication/core/models/facture.dart';
import 'package:sevenapplication/screens/employer/home_employer/components/facture_pdf.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/styles.dart';
import 'package:share_plus/share_plus.dart';

class FactureCard extends StatefulWidget {
  FactureCard(this.facture, {Key? key}) : super(key: key);
  Facture facture;

  @override
  State<FactureCard> createState() => _FactureCardState();
}

class _FactureCardState extends State<FactureCard> {
  bool isClickeddetails = false;
  String text = '';
  List<String> content = [];

  void _showFactureDetailsDialog(BuildContext context, Facture item) {
    print(item.jobber.email);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            textTheme: TextTheme(
              headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              bodyText1: TextStyle(fontSize: 16, color: Colors.black87),
              bodyText2: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          child: AlertDialog(
            title:
                Text('Details Facture', style: TextStyle(color: Colors.blue)),
            content: SizedBox(
              height: 350,
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Jobber', style: TextStyle(color: Colors.blue)),
                    Text(
                      'Nom utilisateur: ${item.jobber.username}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),

                    Text(
                      'Email: ${item.jobber.email}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      'Tél : ${item.jobber.phoneNumber}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(height: 10),
                    Text('Mission', style: TextStyle(color: Colors.blue)),
                    Text('Mission : ${item.mission.title!.name},',
                        style: Theme.of(context).textTheme.bodyText2),
                    Text('Date début : ${item.mission.startDate},',
                        style: Theme.of(context).textTheme.bodyText2),
                    Text(
                      'Date Fin: ${item.mission.endDate}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text('Lieu: ${item.mission.address}',
                        style: Theme.of(context).textTheme.bodyText2),
                    Text(
                        'Localisation: ${item.mission.location!.latitude}, ${item.mission.location!.longitude}',
                        style: Theme.of(context).textTheme.bodyText2),
                    //Text('Status: ${item.mission.status!.name}'),
                    SizedBox(height: 50),
                    Text('Montant à payer',
                        style: TextStyle(color: Colors.blue)),
                    Text(
                      'Total TTC: ${item.mission.title!.price!.toStringAsFixed(2)} €',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  Icon(Icons.print, color: Colors.blue),
                  TextButton(
                      child: Text('Voir facture',
                          style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        //_generateAndSharePDF(item);
                        content.add('Jobber');
                        content.add('Nom utilisateur: ${item.jobber.username}');
                        content.add('Email: ${item.jobber.email}');
                        content.add('Tél : ${item.jobber.phoneNumber}');
                        content.add('Mission');
                        content.add('Mission : ${item.mission.title!.name},');
                        content.add('Date début : ${item.mission.startDate},');
                        content.add('Date Fin: ${item.mission.endDate}');
                        content.add('Lieu: ${item.mission.address}');
                        content.add(
                            'Localisation: ${item.mission.location!.latitude}, ${item.mission.location!.longitude}');
                        //content.add('Status: ${item.mission.status!.name}');
                        content.add('Montant à payer');
                        content.add(
                            'Total TTC: ${item.mission.title!.price!.toStringAsFixed(2)}');
                        content.forEach((element) {
                          text += element + '\n';
                        });
                        setState(() {
                          isClickeddetails = !isClickeddetails;
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FacturePdf(item: item)));
                      }),
                  Spacer(),
                  TextButton(
                    child: Text('Fermer', style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();

                      setState(() {
                        isClickeddetails = !isClickeddetails;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _cartheader(Facture item) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              style: TextStyle(
                  color:
                      item.status == "Due" ? Colors.red : ColorsConst.col_app,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5.sp),
              text: item.mission.title!.price!.toStringAsFixed(2),
              children: [
                TextSpan(
                  text: " €",
                  style: TextStyle(
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w400,
                      color: item.status == "Due"
                          ? Colors.red
                          : ColorsConst.col_app),
                ),
              ],
            ),
          )
        ],
      );
    }

    Widget _FactureCartitem(Facture item) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
        decoration: StylesApp.decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Facture du ${item.createdAt.month.toString()}/${item.createdAt.year.toString()}',
                  style: StylesApp.textStyleM,
                ),
                Container(
                  child: Row(children: [
                    _cartheader(item),
                    Container(
                      width: 20.w,
                    ),
                    Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            //print(item.mission.title!.price!.toStringAsFixed(2));
                            _showFactureDetailsDialog(context, item);
                            setState(() {
                              isClickeddetails = !isClickeddetails;
                            });
                          },
                          child: isClickeddetails
                              ? SvgPicture.asset('assets/icons/details.svg')
                              : SvgPicture.asset('assets/icons/details2.svg'),
                        )),
                  ]),
                )
              ],
            ),
          ],
        ),
      );
    }

    return _FactureCartitem(widget.facture);
  }
}
