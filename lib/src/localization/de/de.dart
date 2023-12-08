import '../localizer.dart';

class DE extends Dictionary{
  //region General
  @override
  String get edit => "Bearbeiten";
  @override
  String get delete => "Löschen";
  //endregion
  //region Menu
  @override
  String get menuAirports => "Flugplätze Verwalten";
  @override
  String get menuSettings => "Einstellungen";
  //endregion
  //region AcSelect
  @override
  String get acSelectTitle => "Luftfahrzeug Auswählen";
  @override
  String get acSelectError => "Kein Luftfahrzeug gefunden!";
  //endregion
}