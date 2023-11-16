import 'package:flutter/material.dart';
import 'package:my_document_scanner/db_helper/database_helper.dart';
import 'package:my_document_scanner/model/pdf_model.dart';
import 'package:my_document_scanner/widgets/pdf_viewer.dart';

class PdfListScreen extends StatefulWidget {
  @override
  _PdfListScreenState createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  late Future<List<PDFItem>> pdfItems;

  @override
  void initState() {
    super.initState();
    refreshPdfList();
  }

  Future<void> refreshPdfList() async {
    setState(() {
      pdfItems = DatabaseHelper.instance.queryAllRows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshPdfList,
        child: FutureBuilder<List<PDFItem>>(
          future: pdfItems,
          builder: (context, snapshot) {
            print(snapshot.error);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Center(child: Text('No Pdf Found!'));
            } else {
              final pdfList = snapshot.data ?? [];
              print('PDF List: $pdfList');
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: pdfList.length,
                itemBuilder: (context, index) {
                  final pdfItem = pdfList[index];
                  print('PDF Path: ${pdfItem.pdfPath}');
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(pdfItem: pdfItem),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf, size: 80, color: Color(0xff46A094).withOpacity(0.5),),
                            const SizedBox(height: 10),
                            Text(
                              pdfItem.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
