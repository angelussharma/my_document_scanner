import 'package:flutter/material.dart';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../db_helper/database_helper.dart';

class ImageDisplayScreen extends StatefulWidget {
  final List<File> images;

  ImageDisplayScreen({Key? key, required this.images}) : super(key: key);

  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  late List<File> _images;
  late String _pdfFileName = ''; // Store the user-entered PDF file name

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
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
        title: Text(
          'Image Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){
                // open a dailog box to write file name
                _showFileNameDialog(context);
             },
              child: Text("Done",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
        ],
      ),
      body: _images.isNotEmpty
          ? Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.file(_images[index], fit: BoxFit.cover);
        },
        itemCount: _images.length,
        pagination: SwiperPagination(),
        control: SwiperControl(),
      )
          : Center(child: Text('No images selected')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: Icon(Icons.edit),
      ),

    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.crop),
              title: Text('Crop Image'),
              onTap: () async {
                Navigator.pop(context);
                final croppedImage = await _cropImage(_images[0]);
                if (croppedImage != null) {
                  setState(() {
                    _images[0] = croppedImage;
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Image'),
              onTap: () {
                Navigator.pop(context);
                _deleteImage(_images[0]);
              },
            ),
          ],
        );
      },
    );
  }

  Future _cropImage(File? imageFile) async {
    if (imageFile != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          aspectRatioPresets:
          [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio7x5
          ],
          uiSettings: [
          AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Color(0xff46A094),
          cropFrameColor: Color(0xff46A094),
          statusBarColor: Color(0xff46A094),
          activeControlsWidgetColor: Color(0xff46A094),
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
          IOSUiSettings(title: 'Crop')
    ]);
      return imageFile = File(cropped!.path);
    }
  }

  void _deleteImage(File imageFile) {
    setState(() {
      _images.remove(imageFile);
    });
  }

  Future<void> _showFileNameDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter PDF File Name'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _pdfFileName = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'File Name'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _createPdfAndSave();
                Navigator.of(context).popAndPushNamed('/home');
              },
              child: Text('Create PDF'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createPdfAndSave() async {
    final pdf = pw.Document();

    for (final imageFile in _images) {
      final image = pw.MemoryImage(File(imageFile.path).readAsBytesSync());
      pdf.addPage(pw.Page(build: (context) {
        return pw.Center(
          child: pw.Image(image),
        );
      }));
    }

    final directory = await getApplicationDocumentsDirectory();
    final pdfPath = '${directory.path}/$_pdfFileName.pdf';
    final file = File(pdfPath);
    await file.writeAsBytes(await pdf.save());

    // Save the PDF file path to SQLite
    await DatabaseHelper.instance.insertPdfFilePath(_pdfFileName, pdfPath, );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_pdfFileName is created'),
      ),
    );
  }

}
