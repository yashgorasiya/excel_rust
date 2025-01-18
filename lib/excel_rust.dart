library excel_rust;

import 'src/rust/api/excel.dart' as api;
import 'src/rust/frb_generated.dart' show RustLib;

abstract class ExcelRust {
  ExcelRust();

  static bool _isLoaded = false;

  factory ExcelRust.instance() => ExcelRustImpl();

  /// only call it once other wise it throws bad state exception
  static Future<void> init() {
    if (_isLoaded) {
      return Future.value();
    }
    _isLoaded = true;
    return RustLib.init();
  }

  List<String> getSheets({required String path});
  Stream<List<String>> readFile({required String path, String? sheet});
}

class ExcelRustImpl implements ExcelRust {
  /// returns List of Sheets(name)
  @override
  List<String> getSheets({required String path}) {
    return api.getSheets(path: path);
  }

  /// [sheet] if sheet name is not provided it will take first one
  /// Stream output=Row
  @override
  Stream<List<String>> readFile({required String path, String? sheet}) {
    return api.readFile(path: path);
  }
}
