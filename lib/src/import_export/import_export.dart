import 'package:flutter/material.dart';
import 'assistant/import_export_assistant.dart';

///API entry point for the import export to call the assistant.
class ImportExport{

  ///Call with context to start the assistant for importing ULPT Data
  static Future<void> startImport({required BuildContext context}) async{
    await ImportExportAssistant.startAssistant(context: context, mode: Mode.import,);
  }

  ///Call with context to start the assistant for exporting ULPT Data
  static Future<void> startExport({required BuildContext context}) async{
    await ImportExportAssistant.startAssistant(context: context, mode: Mode.export,);
  }
}