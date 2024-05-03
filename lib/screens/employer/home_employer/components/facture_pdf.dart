import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sevenapplication/core/models/facture.dart';

class FacturePdf extends StatelessWidget {
  Facture item;
  FacturePdf({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text(
                'Facture du ${item.createdAt.month.toString()}/${item.createdAt.year.toString()}'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: PdfPreview(
          build: (format) => _generatePdf(format, 'Details de la facture'),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final imagejobs = await rootBundle.load('assets/images/jobs2.png');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title,
                      style: pw.TextStyle(
                          fontSize: 30, fontWeight: pw.FontWeight.bold)),
                ),
              ),
              pw.SizedBox(
                width: double.infinity,
                child: pw.Text(
                    "Facture du  ${item.createdAt.day.toString()}/${item.createdAt.month.toString()}/${item.createdAt.year.toString()}"),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                  child: pw.Column(children: [
                pw.Text(
                  'Jobber',
                  style: pw.TextStyle(
                      fontSize: 30, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Nom utilisateur: ${item.jobber.username}',
                  style: pw.TextStyle(
                    fontSize: 25,
                  ),
                ),
                pw.Text(
                  'Email: ${item.jobber.email}',
                  style: pw.TextStyle(
                    fontSize: 25,
                  ),
                ),
                pw.Text(
                  'Tél : ${item.jobber.phoneNumber}',
                  style: pw.TextStyle(
                    fontSize: 25,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Mission',
                  style: pw.TextStyle(
                      fontSize: 30, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Mission : ${item.mission.title!.name},',
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  'Date début : ${item.mission.startDate},',
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  'Date Fin: ${item.mission.endDate}',
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  'Lieu: ${item.mission.address}',
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  'Localisation: ${item.mission.location!.latitude}, ${item.mission.location!.longitude}',
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
                /* pw.Text(
                  'Status: ${item.mission.status!.name}',
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ), */
                pw.SizedBox(height: 20),
                pw.Text(
                  'Montant à payer',
                  style: pw.TextStyle(
                      fontSize: 30, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Total TTC: ${item.mission.title!.price!.toStringAsFixed(2)} Euros',
                  style: pw.TextStyle(
                    fontSize: 30,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(
                      imagejobs.buffer.asUint8List(),
                    ),
                    width: 125,
                    height: 125,
                  ),
                )
              ]))
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
