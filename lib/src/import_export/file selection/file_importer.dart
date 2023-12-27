import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';

///Class for reading data from a user selected file(path).
///Only for .ulpt files
class ULPTFileImporter{

  Future<Uint8List?> importULPTData({Dictionary? dict, String? filePath}) async{

    if(filePath != null) return importULPTDataFromGivenPath(filePath: filePath);

    var file = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      dialogTitle: dict?.importFileTitle ?? "Select .ulpt file to import performance data",
      withData: true,
    );

    if(file == null || file.files.isEmpty) return null;
    assert(file.files.length == 1);
    Uint8List? bytes = file.files.first.bytes;
    if(file.files.first.name.endsWith(".ulpt") == false) bytes = await importULPTData(dict: dict);
    return bytes;
  }

  Future<Uint8List?> importULPTDataFromGivenPath({required String filePath}) async{
    if(filePath.endsWith(".ulpt") == false) throw FormatException("File at $filePath is not a valid .ulpt file");
    var file = File(filePath);
    if((await file.exists()) == false) return null;
    return file.readAsBytes();
  }
}