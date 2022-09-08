import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_const.dart';
import 'color.dart';

ThemeData createTheme({
  Color? color,
  required Brightness brightness,
})  {
  final colorScheme = _getColorScheme(brightness: brightness, color: color);
  // final dynamicColorScheme = await _getDynamicColors(brightness: brightness);
  final appColorScheme = _getAppColorScheme(
    color: color,
    colorScheme: colorScheme,
    // dynamicColorScheme: dynamicColorScheme,
    brightness: brightness,
  );
  final primaryColor = ElevationOverlay.colorWithOverlay(
    appColorScheme.surface,
    appColorScheme.primary,
    3,
  );

  return ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: appColorScheme.materialColorScheme,
    brightness: appColorScheme.brightness,
    scaffoldBackgroundColor: appColorScheme.surface,
    fontFamily: 'Nunito',
    useMaterial3: true,
    typography: Typography.material2021(),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: createOverlayStyle(
        brightness: brightness,
        primaryColor: primaryColor,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      highlightElevation: 0,
    ),
    iconTheme: IconThemeData(
      color: appColorScheme.primary,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            24,
          ),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: appColorScheme.primaryContainer,
      labelStyle: TextStyle(color: appColorScheme.onPrimaryContainer),
    ),
  );
}

SystemUiOverlayStyle createOverlayStyle({
  required Brightness brightness,
  required Color primaryColor,
}) {
  final isDark = brightness == Brightness.dark;

  return SystemUiOverlayStyle(
    systemNavigationBarColor: primaryColor,
    systemNavigationBarContrastEnforced: false,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
  );
}

ColorScheme _getColorScheme({
  Color? color,
  required Brightness brightness,
}) {
  return ColorScheme.fromSeed(
      seedColor: color ?? constants.theme.defaultThemeColor,
      brightness: brightness);
}

// Future<ColorScheme?> _getDynamicColors({required Brightness brightness}) async {
//   try {
//     final corePalette = await DynamicColorPlugin.getCorePalette();
//     return corePalette?.toColorScheme(brightness: brightness);
//   } on PlatformException {
//     return Future.value();
//   }
// }

AppColorScheme _getAppColorScheme({
  Color? color,
  required ColorScheme colorScheme,
  ColorScheme? dynamicColorScheme,
  required Brightness brightness,
}) {
  final isDark = brightness == Brightness.dark;
  return AppColorScheme.fromMaterialColorScheme(
    color != null
        ? colorScheme
        : constants.theme.getColorPaletteFromWallpaper
            ? dynamicColorScheme ?? colorScheme
            : colorScheme,
    disabled: ColorPallette.grey,
    onDisabled: isDark ? ColorPallette.white : ColorPallette.black,
  );
}
