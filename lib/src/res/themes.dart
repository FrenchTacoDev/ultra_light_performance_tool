import 'package:flutter/material.dart';
import 'package:ultra_light_performance_tool/src/shared%20widgets/ulpt_tab_page.dart';
import 'colors.dart';

///Main Theme used for the app. Implements dark and light theme
class ULPTTheme extends ThemeExtension<ULPTTheme>{

  //Todo implement light theme!

  const ULPTTheme({
    required this.baseColor,
    required this.backgroundColor,
    required this.interactiveBGColor,
    required this.interactiveDisabledColor,
    required this.interactiveFocusedColor,
    required this.interactiveHintTextColor,
    required this.interactiveHintDisabledColor,
    required this.interactiveFocusBGColor,
    this.tabPageTheme = const TabPageTheme(),
    this.perfTextWidth = 120,
  });

  ///Used for e.g. Appbar
  final Color baseColor;
  ///Used for background
  final Color backgroundColor;
  final Color interactiveBGColor;
  final Color interactiveDisabledColor;
  final Color interactiveHintTextColor;
  final Color interactiveHintDisabledColor;
  final Color interactiveFocusedColor;
  final Color interactiveFocusBGColor;
  final TabPageTheme tabPageTheme;
  final double perfTextWidth;

  @override
  ThemeExtension<ULPTTheme> copyWith() {
    throw UnimplementedError();
  }

  @override
  ThemeExtension<ULPTTheme> lerp(covariant ThemeExtension<ULPTTheme>? other, double t) {
    throw UnimplementedError();
  }
}

//Todo disabled color
ULPTTheme _darkULPTTheme = ULPTTheme(
  baseColor: CustomColors.bgDark,
  backgroundColor: CustomColors.cardBGdark,
  interactiveBGColor: CustomColors.bgGreyColor,
  interactiveDisabledColor: CustomColors.bgGreyColor.withOpacity(0.4),
  interactiveFocusedColor: Colors.green,
  interactiveHintTextColor: CustomColors.whiteDark,
  interactiveHintDisabledColor: Colors.black54,
  interactiveFocusBGColor: CustomColors.bgGreyColor.withOpacity(0.8),
  tabPageTheme: const TabPageTheme(
    arrowColor: CustomColors.whiteDark,
    dotColor: CustomColors.whiteDark,
  ),
);

ThemeData createDarkTheme(BuildContext context){
  return ThemeData(
    useMaterial3: false,
    appBarTheme: AppBarTheme(
      color: _darkULPTTheme.baseColor,
    ),
    scaffoldBackgroundColor: _darkULPTTheme.baseColor,
    cardColor: _darkULPTTheme.backgroundColor,
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(color: _darkULPTTheme.interactiveHintTextColor, fontSize: 20),
      subtitleTextStyle: TextStyle(color: _darkULPTTheme.interactiveHintTextColor, fontSize: 14,),
      leadingAndTrailingTextStyle: TextStyle(color: _darkULPTTheme.interactiveHintTextColor),
      tileColor: _darkULPTTheme.backgroundColor,
      iconColor: _darkULPTTheme.interactiveHintTextColor,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: _darkULPTTheme.backgroundColor,
      textStyle: TextStyle(color: _darkULPTTheme.interactiveHintTextColor, fontSize: 14),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: _darkULPTTheme.backgroundColor,
      titleTextStyle: TextStyle(
          fontSize: 24,
          color: _darkULPTTheme.interactiveHintTextColor
      ),
      contentTextStyle: TextStyle(
          fontSize: 14,
          color: _darkULPTTheme.interactiveHintTextColor
      ),
    ),
    extensions: [_darkULPTTheme],
    textTheme: TextTheme(
      titleLarge: Theme.of(context).textTheme.titleLarge!.merge(TextStyle(color: _darkULPTTheme.interactiveHintTextColor)),
      bodyLarge: Theme.of(context).textTheme.bodyLarge!.merge(TextStyle(color: _darkULPTTheme.interactiveHintTextColor)),
    ),
  );
}

