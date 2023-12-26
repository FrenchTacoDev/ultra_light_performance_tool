import 'package:flutter_test/flutter_test.dart';
import 'package:ultra_light_performance_tool/src/aircraft/aircraft.dart';
import 'package:ultra_light_performance_tool/src/airports/airports.dart';
import 'package:ultra_light_performance_tool/src/core/settings/settings.dart';
import 'package:ultra_light_performance_tool/src/database/savemanager.dart';
import 'package:ultra_light_performance_tool/src/import_export/file%20processing/file_processing.dart';

import 'performance_calculation_test.dart';

void main() {

  test("Export test objects and import them again to check the data handling works. No Settings and Empty import mock", () async{
    var expBytes = await ExportProcessor.createExportData(saveManager: MockSaveManagerFull());
    var emptyMan = MockSaveManagerEmpty();
    await ImportProcessor.processImportData(data: expBytes, saveManager: emptyMan);
    expect((await emptyMan.getAllAircraft()).length, 2);
    expect((await emptyMan.getAllAirports()).length, 3);
    expect((await emptyMan.getSettings()), null);
  });

  test("Export test objects and import them again to check the data handling works. New Settings and Empty import mock", () async{
    var expBytes = await ExportProcessor.createExportData(saveManager: MockSaveManagerFull(), exportSettings: true);
    var emptyMan = MockSaveManagerEmpty();
    await ImportProcessor.processImportData(data: expBytes, saveManager: emptyMan, importSettings: true);
    expect((await emptyMan.getAllAircraft()).length, 2);
    expect((await emptyMan.getAllAirports()).length, 3);
    expect((await emptyMan.getSettings()), Settings()..corrections = testCorrections);
  });

  test("Export test objects and import them again to check the data handling works. No Settings Full import mock", () async{
    var sm = MockSaveManagerFull();
    var expBytes = await ExportProcessor.createExportData(saveManager: sm);
    await ImportProcessor.processImportData(data: expBytes, saveManager: sm, importSettings: false);
    expect((await sm.getAllAircraft()).length, 2);
    expect((await sm.getAllAirports()).length, 3);
  });

  test("Export test objects and import them again to check the data handling works. New Settings Full import mock", () async{
    var sm = MockSaveManagerFull();
    var settings = await sm.getSettings();
    var expBytes = await ExportProcessor.createExportData(saveManager: sm, exportSettings: true);
    await ImportProcessor.processImportData(data: expBytes, saveManager: sm, importSettings: true);
    expect((await sm.getAllAircraft()).length, 2);
    expect((await sm.getAllAirports()).length, 3);
    expect((await sm.getSettings()), settings);
  });
}

class MockSaveManagerFull extends SaveManager{
  Settings? settings;

  @override
  Future<List<Aircraft>> getAllAircraft() async{
    return [kiebitz, fk9];
  }

  @override
  Future<List<Airport>> getAllAirports() async{
    return [edfo, edry, eddf];
  }

  @override
  Future<Settings?> getSettings() async{
    settings = settings ?? Settings()..corrections = testCorrections;
    return settings;
  }

  @override
  Future<void> saveSettings({required Settings settings}) async{
    this.settings = settings;
  }
}

class MockSaveManagerEmpty extends SaveManager{

  List<Aircraft> ac = [];
  List<Airport> ap = [];
  int num = 0;
  Settings? settings;

  @override
  Future<List<Aircraft>> getAllAircraft() async{
    return ac;
  }

  @override
  Future<List<Airport>> getAllAirports() async{
    return ap;
  }

  @override
  Future<int> addAircraft({required Aircraft aircraft}) async{
    ac.add(aircraft);
    return num++;
  }

  @override
  Future<int> addAirport({required Airport airport}) async{
    ap.add(airport);
    return num++;
  }

  @override
  Future<Settings?> getSettings() async{
    return settings;
  }

  @override
  Future<void> saveSettings({required Settings settings}) async{
    this.settings = settings;
  }
}