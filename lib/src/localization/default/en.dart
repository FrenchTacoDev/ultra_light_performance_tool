///Data container for all Strings that will be implemented by the localization
abstract class Dictionary{
  //region General
  String get edit;
  String get delete;
  //endregion

  //region Menu
  String get menuAirports;
  String get menuSettings;

  //region AcSelect
  String get acSelectTitle;
  String get acSelectError;
  //endregion
}

class EN extends Dictionary{
  //region General
  @override
  String get edit => "Edit";
  @override
  String get delete => "Delete";
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
  String get acSelectError => "No Aircraft found!";
  //endregion
}