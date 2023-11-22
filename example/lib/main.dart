import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ultra_light_performance_tool/ulpt.dart';


void main() {

  if(io.Platform.isWindows ||io.Platform.isMacOS){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const ULPT());
}
