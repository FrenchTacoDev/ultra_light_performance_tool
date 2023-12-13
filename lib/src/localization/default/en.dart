///Data container for all Strings that will be implemented by the localization
abstract class Dictionary{
  //region General
  String get yes;
  String get no;
  String get ok => "OK";
  String get edit;
  String get delete;
  String get save;
  String get enter;
  String get select;
  String get reset;
  String get runway;
  String get runways;
  String get full;
  String get toda;
  //endregion

  //region Menu
  //region Menu
  String get menuAirports;
  String get menuSettings;
  //endregion

  //region AcSelect
  String get acSelectTitle;
  String get acSelectNotFound;
  String acDeleteConfirm(String acName);
  //endregion

  //region AddAC
  String get addACTitleCreate;
  String get addACTitleEdit;
  String get addACNameHint;
  String get addACTodHint;
  //endregion

  //region Settings
  //Settings title is same as menuSettings
  String get facAdjustTitle;
  String get facAdjustSubTitle;
  //endregion

  //region FacAdjust
  String get faWindTitle;
  String get faHw;
  String get faTw;
  String get faGrassTitle;
  String get faGrassFirm;
  String get faGrassWet;
  String get faGrassSoftened;
  String get faGrassSodDamaged;
  String get faGrassHigh;
  String get faConditionTitle;
  String get faConWet;
  String get faConStandWater;
  String get faConSlush;
  String get faConWetSnow;
  String get faConDrySnow;
  //endregion

  //region APManage
  String get apManageDeleteConfirm;
  String get apManageNotFound;
  //endregion

  //region AddAP
  String get apAddTitle;
  String get apEditTitle;
  String get apNameHint;
  String get apIcaoHint => "ICAO Code";
  String get apIataHint => "IATA Code";
  String get apElevHint;
  String get deleteRunwayConfirm;
  //endregion

  //region AddRunway
  String get rwyAddTitle;
  String get rwyEditTitle;
  String get rwyNameHint;
  String get rwyDirHint;
  String get rwySrfcDropdownHint;
  String get rwyStartElevHint;
  String get rwyEndElevHint;
  String get rwySlopeHint;
  String get rwyIntersectNameHint;
  String get rwyIntersectDelConfirm;
  String get rwyCrsErrorTitle;
  String get rwyCrsErrorText;
  //endregion

  //region Surface
  String get rwyAsphalt;
  String get rwyGrass;
  //endregion

  //region Underground
  String get firm;
  String get wet;
  String get softened;
  //endregion

  //region RunwayCondition
  String get condDry;
  String get condWet;
  String get condStandingWater;
  String get condSlush;
  String get condWetSnow;
  String get condDrySnow;
  //endregion

  //region PerfCalc
  String get pcCalc;
  String get pcEnterData;
  String get pcAPTitle;
  String get pcRwyTitle;
  String get pcIntersectTitle;
  String get pcGrasCondTitle;
  String get pcGrasCondHint;
  String get pcSodDamaged;
  String get pcHighGrass;
  String get pcCondTitle;
  String get pcTempTitle;
  String get pcTempInvalidTitle;
  String get pcTempTooHigh;
  String get pcTempTooLow;
  String get pcWindTitle;
  String get pcWindErrorTitle;
  String get pcWindFormatError;
  String get pcWindDirError;
  String get pcWindSpdError;
  String get pcQnhTitle;
  String get pcQnhError;
  String get pcQnhTooHigh;
  String get pcQnhTooLow;
  String get pcMarginTitle;
  String get pcMarginHint;
  String get pcToda;
  String get pcTod;
  String get pcTodMargin;
  String get pcRunwayRemain;
  String pcNotEnoughRunway(int overshoot);
  String pcNotEnoughRunwayMargin(int overshoot);
  //endregion
}

class EN extends Dictionary{
  //region General
  @override
  String get yes => "Yes";
  @override
  String get no => "No";
  @override
  String get edit => "Edit";
  @override
  String get delete => "Delete";
  @override
  String get save => "Save";
  @override
  String get enter => "Enter";
  @override
  String get select => "Select";
  @override
  String get reset => "Reset";
  @override
  String get runway => "Runway";
  @override
  String get runways => "Runways";
  @override
  String get full => "Full";
  @override
  String get toda => "Takeoff Distance Available";
  //endregion

  //region Menu
  @override
  String get menuAirports => "Manage Airports";
  @override
  String get menuSettings => "Settings";
  //endregion
  //region AcSelect
  @override
  String get acSelectTitle => "Select Aircraft";
  @override
  String get acSelectNotFound => "No Aircraft found!";
  @override
  String acDeleteConfirm(String acName) => "Delete aircraft $acName?";
  //endregion
  //region AddAC
  @override
  String get addACTitleCreate => "Add Aircraft";
  @override
  String get addACTitleEdit => "Edit Aircraft";
  @override
  String get addACNameHint => "AC Name or Registration";
  @override
  String get addACTodHint => "Dry Runway Takeoff Distance";
  //endregion
  //region Settings
  //Settings title is same as menuSettings
  @override
  String get facAdjustTitle => "Adjust Factors";
  @override
  String get facAdjustSubTitle => "Adjust the factors used in the performance calculation";
  //endregion
  //region FacAdjust
  @override
  String get faWindTitle => "Wind Influence in %";
  @override
  String get faHw => "Headwind per 10kt (minus)";
  @override
  String get faTw => "Tailwind per 10kt (plus)";
  @override
  String get faGrassTitle => "Corrections Grass Runway in %";
  @override
  String get faGrassFirm => "Grass Runway: firm, dry, flat (max 3cm)";
  @override
  String get faGrassWet => "Grass Runway: wet";
  @override
  String get faGrassSoftened => "Grass Runway: softened";
  @override
  String get faGrassSodDamaged => "Grass Sod damaged";
  @override
  String get faGrassHigh => "High Gras (3-8cm)";
  @override
  String get faConditionTitle => "Corrections Runway Condition in %";
  @override
  String get faConWet => "Wet";
  @override
  String get faConStandWater => "Standing Water";
  @override
  String get faConSlush => "Slush (max 1cm)";
  @override
  String get faConWetSnow => "Wet Snow (max 5cm)";
  @override
  String get faConDrySnow => "Dry Snow (max 8cm)";
  //endregion
  //region APManage
  @override
  String get apManageDeleteConfirm => "Delete Airport?";
  @override
  String get apManageNotFound => "No Airports found!";
  //endregion
  //region AddAP
  @override
  String get apAddTitle => "Add Airport";
  @override
  String get apEditTitle => "Edit Airport";
  @override
  String get apNameHint => "Airport Name";
  @override
  String get apElevHint => "Airport Elevation";
  @override
  String get deleteRunwayConfirm => "Delete Runway?";
  //endregion
  //region AddRunway
  @override
  String get rwyAddTitle => "Add Runway";
  @override
  String get rwyEditTitle => "Edit Runway";
  @override
  String get rwyNameHint => "Runway Name";
  @override
  String get rwyDirHint => "Runway Direction";
  @override
  String get rwySrfcDropdownHint => "Runway Surface";
  @override
  String get rwyStartElevHint => "Runway Start Elevation";
  @override
  String get rwyEndElevHint => "Runway End Elevation";
  @override
  String get rwySlopeHint => "Runway Slope";
  @override
  String get rwyIntersectNameHint => "Intersection Name";
  @override
  String get rwyIntersectDelConfirm => "Delete Intersection?";
  @override
  String get rwyCrsErrorTitle => "Invalid Course";
  @override
  String get rwyCrsErrorText => "The course must be within 0 to 360 degrees!";
  //endregion
  //region Surface
  @override
  String get rwyAsphalt => "Asphalt";
  @override
  String get rwyGrass => "Grass";
  //endregion
  //region Underground
  @override
  String get firm => "firm, dry, flat";
  @override
  String get wet => "wet";
  @override
  String get softened => "softened";
  //endregion
  //region RunwayCondition
  @override
  String get condDry => "Dry";
  @override
  String get condWet => "Wet";
  @override
  String get condStandingWater => "Standing Water";
  @override
  String get condSlush => "Slush";
  @override
  String get condWetSnow => "Wet Snow";
  @override
  String get condDrySnow => "Dry Snow";
  //endregion
  //region PerfCalc
  @override
  String get pcCalc => "CALCULATE";
  @override
  String get pcEnterData => "Insert Data";
  @override
  String get pcAPTitle => "Airport";
  @override
  String get pcRwyTitle => runway;
  @override
  String get pcIntersectTitle => "Intersection";
  @override
  String get pcGrasCondTitle => "Grass";
  @override
  String get pcGrasCondHint => "Underground";
  @override
  String get pcSodDamaged => "Sod damaged?";
  @override
  String get pcHighGrass => "High grass?";
  @override
  String get pcCondTitle => "Condition";
  @override
  String get pcTempTitle => "Temperature";
  @override
  String get pcTempInvalidTitle => "Invalid Temperature";
  @override
  String get pcTempTooHigh => "The temperature is too high.\nPlease check.";
  @override
  String get pcTempTooLow => "The temperature is to low.\nPlease check.";
  @override
  String get pcWindTitle => "Wind";
  @override
  String get pcWindErrorTitle => "Invalid Wind";
  @override
  String get pcWindFormatError => "Wind format is wrong!\nPlease check.";
  @override
  String get pcWindDirError => "Wind direction must be within 0° to 360°!";
  @override
  String get pcWindSpdError => "Wind velocity must be positive!";
  @override
  String get pcQnhTitle => "QNH";
  @override
  String get pcQnhError => "Invalid QNH";
  @override
  String get pcQnhTooHigh => "QNH is too high.\nPlease check.";
  @override
  String get pcQnhTooLow => "QNH is too low.\nPlease check.";
  @override
  String get pcMarginTitle => "Margin";
  @override
  String get pcMarginHint => "Margin in %";
  @override
  String get pcToda => "Takeoff Distance Available";
  @override
  String get pcTod => "Takeoff Distance no Margin";
  @override
  String get pcTodMargin => "Takeoff Distance with Margin";
  @override
  String get pcRunwayRemain => "Remaining Runway";
  @override
  String pcNotEnoughRunway(int overshoot) => "Takeoff distance insufficient.\n${overshoot}m more needed!";
  @override
  String pcNotEnoughRunwayMargin(int overshoot) => "Takeoff distance with margin insufficient.\n${overshoot}m more needed!";
  //endregion
}