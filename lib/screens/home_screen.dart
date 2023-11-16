import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_document_scanner/screens/editor_screen.dart';
import '../widgets/pdf_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<File> images = [];
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImageDisplayScreen(images: images),
        ),
      );

    }
  }


  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImageDisplayScreen(images: images),
        ),
      );

    }
  }

  // Future<List<PDFItem>> _convertImagesToPDF() async {
  //   List<PDFItem> pdfItems = [];
  //   int id = 0;
  //
  //   for (var imageFile in images) {
  //     final pdf = pw.Document();
  //
  //     final image = pw.MemoryImage(
  //       imageFile.readAsBytesSync(),
  //     );
  //
  //     pdf.addPage(pw.Page(
  //       build: (pw.Context context) => pw.Center(child: pw.Image(image)),
  //     ));
  //
  //     // Convert to Uint8List and create PDFItem
  //     Uint8List pdfData = await pdf.save();
  //     pdfItems.add(PDFItem(
  //       id: id++,
  //       name: "Document_${id}.pdf",
  //       pdfData: pdfData,
  //     ));
  //   }
  //
  //   return pdfItems;
  // }
  //

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff46A094),
        toolbarHeight: 70,
        title: const Text('ScanMate',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.white),
            );
          },
        ),
      ),
      drawer: Drawer(
        elevation: 8.0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xff46A094),),
                accountName: Text(
                  "ScanMate",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  " ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: Image.asset('assets/logo_light.png', height: 100,),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                ),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const AboutListTile(
                icon: Icon(
                  Icons.info,
                ),
                child: Text('About app'),
                applicationIcon: Icon(
                  Icons.local_play,
                ),
                applicationName: 'My Document Scanner',
                applicationVersion: '1.0.0',
                applicationLegalese: '©2023 Insane Coder',
                aboutBoxChildren: [
                ],
              ),
            ],
          )
      ),
      body: PdfListScreen(),

      floatingActionButton: Container(
        padding: const EdgeInsets.all(20),
        child: SpeedDial(
          useRotationAnimation: true,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 30.0),
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: const Color(0xffC4E8C2),
          overlayOpacity: 0.5,
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: const Color(0xff46A094),
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.camera, color: Colors.white,),
              backgroundColor: const Color(0xff46A094),
              label: 'Camera',
              labelStyle: const TextStyle(fontSize: 16.0),
              onTap: () {
                _pickImageFromCamera();
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.image, color: Colors.white,),
              backgroundColor: const Color(0xff46A094),
              label: 'Gallery',
              labelStyle: const TextStyle(fontSize: 16.0),
              onTap: () {
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }
}
