import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel_rust/excel_rust.dart';

Future<void> main() async {
  await ExcelRust.init();
  runApp(const MyApp());
}

void readExcel(String filepath) async {
  final ExcelRust excelRust = ExcelRust.instance();
  List<String> sheets = excelRust.getSheets(path: filepath);

  Stream<List<String>> rows = excelRust.readFile(
    path: filepath,
    sheet: sheets.first,
  );
  await for (List<String> row in rows) {
    // Your business logic
    print(row);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Excel Rust')),
        body: Center(
          child: FilledButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                readExcel(result.files.first.path!);
              }
            },
            child: const Text("Pick File"),
          ),
        ),
      ),
    );
  }
}
