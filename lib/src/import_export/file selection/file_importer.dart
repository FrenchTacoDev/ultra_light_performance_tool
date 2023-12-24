import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';

///Class for reading data from a user selected file(path).
///Only for .ulpt files
class ULPTFileImporter{

  Future<Uint8List?> importULPTData({Dictionary? dict}) async{

    var file = await FilePicker.platform.pickFiles(
      allowedExtensions: ["ulpt"],
      allowMultiple: false,
      dialogTitle: dict?.importFileTitle ?? "Select .ulpt file to import performance data",
      withData: true,
    );

    if(file == null || file.files.isEmpty) return null;
    assert(file.files.length == 1);
    if(file.files.first.name.endsWith(".ulpt") == false) throw(const FormatException("File is no .ulpt file"));
    return file.files.first.bytes;
  }
}