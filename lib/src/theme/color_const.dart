import 'package:flutter/material.dart';

class ColorPallette {
  static const Color primaryColor = Color(0xff1ABC9C);
  static const Color backgroundColor = Color(0xff1E1E1E);
  static const Color orange = Color(0xffF39C12);
  static const Color purple = Color(0xff9997FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
}

final constants = Constants();

class Constants {
  late final theme = _Theme();
}

class _Theme {
  final defaultThemeColor = ColorPallette.primaryColor;
  final getColorPaletteFromWallpaper = true;
  List<Color> themeColors = const [
    Color(0xFFFF0000),
    Color(0xFFFF8000),
    Color(0xFFFCCC1A),
    Color(0xFF66B032),
    Color(0xFF00FFFF),
    Color(0xFF0000FF),
    Color(0xFF0080FF),
    Color(0xFFFF00FF),
  ];
}
