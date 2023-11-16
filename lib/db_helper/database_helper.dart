import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/pdf_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    print("initDB executed");
    String path = join(await getDatabasesPath(), 'pdfs.db');
    print("Database path: $path");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        print("onCreate executed");
        await db.execute('''
        CREATE TABLE IF NOT EXISTS pdf_files (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          file_path TEXT
        )
      ''');
      },
    );

}

  // Future<void> _createDatabase(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE IF NOT EXISTS pdf_files (
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       file_path TEXT
  //     )
  //   ''');
  // }

  Future<int> insertPdfFilePath(String fileName, String filePath) async {
    Database db = await instance.database;
    return await db.insert('pdf_files', {'name': fileName, 'file_path': filePath});
  }

  Future<Uint8List> getPdfData(String pdfPath) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'pdf_files',
      where: 'file_path = ?',
      whereArgs: [pdfPath],
    );

    if (result.isNotEmpty) {
      return result[0]['pdf_data'];
    } else {
      throw Exception('PDF data not found for path: $pdfPath');
    }
  }


  Future<List<PDFItem>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('pdf_files');
    print('ahfvhavf$result');
    print('kjdbsvk${result.map((map) => PDFItem.fromMap(map)).toList()}');
    return result.map((map) => PDFItem.fromMap(map)).toList();
  }

}
