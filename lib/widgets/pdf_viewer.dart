import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:my_document_scanner/model/pdf_model.dart';

class PdfViewerScreen extends StatelessWidget {
  final PDFItem pdfItem;

  const PdfViewerScreen({super.key, required this.pdfItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            );
          },
        ),
        title: Text(pdfItem.name,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SfPdfViewer.file(File(pdfItem.pdfPath)),
    );
  }
}
