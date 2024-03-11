import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_storage/shared_storage.dart' as saf;
import 'package:ultra_light_performance_tool/src/core/core.dart';

///Class for writing data to a user selected file(path).
class ULPTFileExporter{

  ///If [dict] is provided, will localize the export message for the user.
  Future<void> exportULPTData({required Uint8List data, required Size screenSize, Dictionary? dict}) async{
    if(Platform.isWindows || Platform.isMacOS) return _DesktopExporter().exportULPTData(data: data, screenSize: screenSize);
    if(Platform.isAndroid) return _AndroidExplorer().exportULPTData(data: data, screenSize: screenSize);
    var filePath = join((await getTemporaryDirectory()).path, "PerfData.ulpt");

    var file = File(filePath);
    if(await file.exists()) await file.delete(recursive: true);
    await file.create(recursive: true);

    await file.writeAsBytes(data);

    await Share.shareXFiles(
      [XFile(filePath)],
      sharePositionOrigin: Rect.fromLTRB(0, 0, screenSize.width, 16),
    );
  }
}

///Subclass used on Android. Is private bc should only be selected by the main function
class _AndroidExplorer extends ULPTFileExporter{
  @override
  Future<void> exportULPTData({required Uint8List data,  required Size screenSize, Dictionary? dict}) async{

    //Use cached file in share sheet so user can directly share.
    var fileName = "PerfData.ulpt";

    var cacheFile = File(join((await getTemporaryDirectory()).path, fileName));
    if(await cacheFile.exists()) await cacheFile.delete(recursive: true);
    await cacheFile.create(recursive: true);
    await cacheFile.writeAsBytes(data);

    var uri = await saf.openDocumentTree();

    if(uri != null){
      await saf.createFileAsBytes(uri, mimeType: "application/octet-stream", displayName: fileName, bytes: data);
    }

    await Share.shareXFiles(
      [XFile(cacheFile.path)],
      sharePositionOrigin: Rect.fromLTRB(0, 0, screenSize.width, 16),
    );

    await cacheFile.delete(recursive: true);
  }
}

///Subclass used on Desktop. Is private bc should only be selected by the main function
class _DesktopExporter extends ULPTFileExporter{

  @override
  Future<void> exportULPTData({required Uint8List data,  required Size screenSize, Dictionary? dict}) async{
    var filePath = await FilePicker.platform.saveFile(
        dialogTitle: dict?.saveFileTitle ?? "Save ULPT Data",
        fileName: "PerfData.ulpt",
        allowedExtensions: ["ulpt"]
    );

    if(filePath == null) return;

    if(filePath.endsWith(".ulpt") == false) filePath += ".ulpt";
    var file = File(filePath);
    if(await file.exists()) await file.delete(recursive: true);
    await file.create(recursive: true);
    await file.writeAsBytes(data);
  }

}