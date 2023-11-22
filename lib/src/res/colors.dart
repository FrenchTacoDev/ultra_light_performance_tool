import 'package:flutter/material.dart';

///Contains the colors used in the ULPT Themes
class CustomColors{

  static const MaterialColor bgGrey = MaterialColor(
      _bgGreyPrimary,
      {
        50: Color(_bgGreyPrimary),
        100: Color(_bgGreyPrimary),
        200: Color(_bgGreyPrimary),
        300: Color(_bgGreyPrimary),
        350: Color(_bgGreyPrimary), // only for raised button while pressed in light theme
        400: Color(_bgGreyPrimary),
        500: Color(_bgGreyPrimary),
        600: Color(_bgGreyPrimary),
        700: Color(_bgGreyPrimary),
        800: Color(_bgGreyPrimary),
        850: Color(_bgGreyPrimary), // only for background color in dark theme
        900: Color(_bgGreyPrimary),
      }
  );

  static const int _bgGreyPrimary = 0xFF424242;
  static const Color bgGreyColor = Color(_bgGreyPrimary);
  static const bgDark = Color(0xFF000000);
  static const cardBGdark = Color(0xFF1b1c21);
  static const whiteBright = Color(0xFFffffff);
  static const whiteDark = Color(0xFFc6cdd3);
}