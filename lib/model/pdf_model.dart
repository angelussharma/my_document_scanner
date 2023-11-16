class PDFItem {
  final int id;
  final String name;
  final String pdfPath;

  PDFItem({required this.id, required this.name, required this.pdfPath});

  factory PDFItem.fromMap(Map<String, dynamic> map) {
    return PDFItem(
      id: map['id'],
      name: map['name'] ?? '',
      pdfPath: map['file_path'] ?? '',
    );
  }
}
