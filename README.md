# excel_rust

Read large excel file iteratively. It uses rust calamine library.

## Getting Started
```
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

```