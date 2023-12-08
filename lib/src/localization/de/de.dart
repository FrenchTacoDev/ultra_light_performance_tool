import '../localizer.dart';

class DE extends Dictionary{
  //region General
  @override
  String get yes => "Ja";
  @override
  String get no => "Nein";
  @override
  String get edit => "Bearbeiten";
  @override
  String get delete => "Löschen";
  @override
  String get save => "Speichern";
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
  @override
  String acDeleteConfirm(String acName) => "$acName wirklich löschen?";
  //endregion
  //region AddAC
  @override
  String get addACTitleCreate => "Luftfahrzeug Hinzufügen";
  @override
  String get addACTitleEdit => "Luftfahrzeug Bearbeiten";
  @override
  String get addACNameHint => "Name oder Registrierung des Luftfahrzeugs";
  @override
  String get addACTodHint => "Startstrecke auf trockener Bahn";
  //endregion
}