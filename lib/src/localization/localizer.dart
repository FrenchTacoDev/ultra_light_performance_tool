import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_light_performance_tool/src/core/core.dart';
import 'default/en.dart';
import 'de/de.dart';
export 'default/en.dart' show Dictionary;

Dictionary _defaultDict = EN();
Map<String, Dictionary> _localMap = {
  "de" : DE()
};

///Inherited Widget that is used to localize the app.
///To get a localized string call [Localizer.of(context).exampleString]
class Localizer extends InheritedWidget{
  const Localizer({super.key, required super.child});

  Dictionary std({required BuildContext context}){
    var local = context.read<ApplicationCubit>().settings.locale ?? Localizations.localeOf(context);
    var res = _localMap[local.languageCode];
    if(res == null) return _defaultDict;
    return res;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget != this;
  }

  static Dictionary? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Localizer>()?.std(context: context);
  }

  static Dictionary of(BuildContext context) {
    final Dictionary? result = maybeOf(context);
    assert(result != null, 'No Localizer found in context');
    return result!;
  }
}





