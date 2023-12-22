import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';

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

    return file.files.first.bytes;
  }
}