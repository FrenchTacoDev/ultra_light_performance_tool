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
  String get enter => "Eingeben";
  @override
  String get select => "Auswählen";
  @override
  String get reset => "Zurücksetzen";
  @override
  String get runway => "Piste";
  @override
  String get runways => "Pisten";
  @override
  String get full => "Voll";
  @override
  String get toda => "Verfügbare Startdistanz";
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
  //region AddAP
  @override
  String get apAddTitle => "Flugplatz hinzufügen";
  @override
  String get apEditTitle => "Flugplatz bearbeiten";
  @override
  String get apNameHint => "Name des Flugplatzes";
  @override
  String get apElevHint => "Flugplatzhöhe";
  @override
  String get deleteRunwayConfirm => "Piste löschen?";
  //endregion
  //region AddRunway
  @override
  String get rwyAddTitle => "Piste hinzufügen";
  @override
  String get rwyEditTitle => "Piste bearbeiten";
  @override
  String get rwyNameHint => "Pistenbezeichnung";
  @override
  String get rwyDirHint => "Pistenausrichtung in Grad";
  @override
  String get rwySrfcDropdownHint => "Bahnbelag";
  @override
  String get rwyStartElevHint => "Pistenanfangshöhe";
  @override
  String get rwyEndElevHint => "Pistenendhöhe";
  @override
  String get rwySlopeHint => "Pistenneigung";
  @override
  String get rwyIntersectNameHint => "Pistenkreuzungsbezeichnung";
  @override
  String get rwyIntersectDelConfirm => "Pistenkreuzung löschen?";
  @override
  String get rwyCrsErrorTitle => "Ungültiger Kurs";
  @override
  String get rwyCrsErrorText => "Der Kurs muss zwischen 0 und 360° liegen!";
  //endregion
  //region Surface
  @override
  String get rwyAsphalt => "Asphalt";
  @override
  String get rwyGrass => "Gras";
  //endregion
  //region Underground
  @override
  String get firm => "fest, trocken, eben";
  @override
  String get wet => "feucht";
  @override
  String get softened => "aufgeweicht";
  //endregion
  //region RunwayCondition
  @override
  String get condDry => "Trocken";
  @override
  String get condWet => "Nass";
  @override
  String get condStandingWater => "Stehendes Wasser";
  @override
  String get condSlush => "Schneematsch";
  @override
  String get condWetSnow => "Normalfeuchter Schnee";
  @override
  String get condDrySnow => "Pulver Schnee";
  //endregion
  //region PerfCalc
  @override
  String get pcCalc => "BERECHNEN";
  @override
  String get pcEnterData => "Daten Eingeben";
  @override
  String get pcAPTitle => "Flugplatz";
  @override
  String get pcRwyTitle => runway;
  @override
  String get pcIntersectTitle => "Kreuzung";
  @override
  String get pcGrasCondTitle => "Gras";
  @override
  String get pcGrasCondHint => "Untergrund";
  @override
  String get pcSodDamaged => "Grasnarbe beschädigt?";
  @override
  String get pcHighGrass => "Hohes Gras?";
  @override
  String get pcCondTitle => "Zustand";
  @override
  String get pcTempTitle => "Temperatur";
  @override
  String get pcTempInvalidTitle => "Ungültige Temperatur";
  @override
  String get pcTempTooHigh => "Die Temperatur ist zu hoch.\nBitte überprüfen.";
  @override
  String get pcTempTooLow => "Die Temperatur ist zu niedrig.\nBitte überprüfen.";
  @override
  String get pcWindTitle => "Wind";
  @override
  String get pcWindErrorTitle => "Ungültiger Wind";
  @override
  String get pcWindFormatError => "Windformat ist falsch!\nBitte überprüfen.";
  @override
  String get pcWindDirError => "Windrichtung muss zwischen 0° und 360° sein!";
  @override
  String get pcWindSpdError => "Windgeschwindigkeit muss positiv sein!";
  @override
  String get pcQnhTitle => "QNH";
  @override
  String get pcQnhError => "Ungültiges QNH";
  @override
  String get pcQnhTooHigh => "QNH ist zu hoch.\nBitte überprüfen.";
  @override
  String get pcQnhTooLow => "QNH ist zu niedrig.\nBitte überprüfen.";
  @override
  String get pcMarginTitle => "Aufschlag";
  @override
  String get pcMarginHint => "Aufschlag in %";
  @override
  String get pcToda => "Verfügbare Startdistanz";
  @override
  String get pcTod => "Startstrecke ohne Aufschlag";
  @override
  String get pcTodMargin => "Startstrecke mit Aufschlag";
  @override
  String get pcRunwayRemain => "Verbleibende Pistenlänge";
  @override
  String pcNotEnoughRunway(int overshoot) => "Startdistanz nicht ausreichend.\n${overshoot}m mehr benötigt!";
  @override
  String pcNotEnoughRunwayMargin(int overshoot) => "Startdistanz mit Aufschlag nicht ausreichend.\n${overshoot}m mehr benötigt!";
  //endregion
}