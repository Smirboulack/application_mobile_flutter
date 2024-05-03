import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:sevenapplication/core/models/mission_model.dart';
import 'pdf/pdfexport.dart';

class PdfPreviewPage extends StatelessWidget {
  final MissionModel mission;
  const PdfPreviewPage({Key? key, required this.mission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contrat'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(mission),
      ),
    );
  }
}
