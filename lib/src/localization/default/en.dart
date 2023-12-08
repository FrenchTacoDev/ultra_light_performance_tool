///Data container for all Strings that will be implemented by the localization
abstract class Dictionary{
  //region General
  String get yes;
  String get no;
  String get edit;
  String get delete;
  String get save;
  //endregion

  //region Menu
  String get menuAirports;
  String get menuSettings;

  //region AcSelect
  String get acSelectTitle;
  String get acSelectError;
  String acDeleteConfirm(String acName);
  //endregion

  //region AddAC
  String get addACTitleCreate;
  String get addACTitleEdit;
  String get addACNameHint;
  String get addACTodHint;
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
  //endregion

  //region Menu
  @override
  String get menuAirports => "Manage Airports";
  @override
  String get menuSettings => "Settings";
  @override
  String acDeleteConfirm(String acName) => "Delete aircraft $acName?";
  //endregion
  //region AcSelect
  @override
  String get acSelectTitle => "Select Aircraft";
  @override
  String get acSelectError => "No Aircraft found!";
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
}