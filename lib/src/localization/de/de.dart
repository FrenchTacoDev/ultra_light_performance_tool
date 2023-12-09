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
  @override
  String get reset => "Zurücksetzen";
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
  String get acSelectNotFound => "Kein Luftfahrzeug gefunden!";
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
  //region Settings
  //Settings title is same as menuSettings
  @override
  String get facAdjustTitle => "Faktoren Anpassen";
  @override
  String get facAdjustSubTitle => "Passen Sie die Faktoren für die Performance-Berechnung an.";
  //endregion
  //region FacAdjust
  @override
  String get faWindTitle => "Windeinfluss in %";
  @override
  String get faHw => "Gegenwind pro 10kt (minus)";
  @override
  String get faTw => "Rückenwind pro 10kt (plus)";
  @override
  String get faGrassTitle => "Korrektur Grasbahn in %";
  @override
  String get faGrassFirm => "Grasbahn: fest, trocken, eben (Bewuchs bis 3cm)";
  @override
  String get faGrassWet => "Grasbahn: feucht";
  @override
  String get faGrassSoftened => "Grasbahn: aufgeweicht";
  @override
  String get faGrassSodDamaged => "Grasnarbe beschädigt";
  @override
  String get faGrassHigh => "Hohes Gras (3-8cm)";
  @override
  String get faConditionTitle => "Korrektur Pistenzustand in %";
  @override
  String get faConWet => "Nass";
  @override
  String get faConStandWater => "Stehendes Wasser";
  @override
  String get faConSlush => "Schneematsch (max 1cm)";
  @override
  String get faConWetSnow => "Normalfeuchter Schnee (max 5cm)";
  @override
  String get faConDrySnow => "Pulverschnee (max 8cm)";
  //endregion
  //region APManage
  @override
  String get apManageDeleteConfirm => "Flugplatz wiklich löschen?";
  @override
  String get apManageNotFound => "Keine Flugplätze gefunden!";
  //endregion
}