import 'package:flutter/material.dart';

typedef MaterialColorScheme = ColorScheme;

class AppColorScheme {
  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color shadow;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;
  final Color disabled;
  final Color onDisabled;

  AppColorScheme({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.shadow,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.disabled,
    required this.onDisabled,
  });

  factory AppColorScheme.fromMaterialColorScheme(ColorScheme colorScheme,
      {required Color disabled, required Color onDisabled}) {
    return AppColorScheme(
      brightness: colorScheme.brightness,
      primary: colorScheme.primary,
      onPrimary: colorScheme.onPrimary,
      primaryContainer: colorScheme.primaryContainer,
      onPrimaryContainer: colorScheme.onPrimaryContainer,
      secondary: colorScheme.secondary,
      onSecondary: colorScheme.onSecondary,
      secondaryContainer: colorScheme.secondaryContainer,
      onSecondaryContainer: colorScheme.onSecondaryContainer,
      tertiary: colorScheme.tertiary,
      onTertiary: colorScheme.onTertiary,
      tertiaryContainer: colorScheme.tertiaryContainer,
      onTertiaryContainer: colorScheme.onTertiaryContainer,
      error: colorScheme.error,
      onError: colorScheme.onError,
      errorContainer: colorScheme.errorContainer,
      onErrorContainer: colorScheme.onErrorContainer,
      background: colorScheme.background,
      onBackground: colorScheme.onBackground,
      surface: colorScheme.surface,
      onSurface: colorScheme.onSurface,
      surfaceVariant: colorScheme.surfaceVariant,
      onSurfaceVariant: colorScheme.onSurfaceVariant,
      outline: colorScheme.outline,
      shadow: colorScheme.shadow,
      inverseSurface: colorScheme.inverseSurface,
      onInverseSurface: colorScheme.onInverseSurface,
      inversePrimary: colorScheme.inversePrimary,
      disabled: disabled,
      onDisabled: onDisabled,
    );
  }

  MaterialColorScheme get materialColorScheme => MaterialColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        shadow: shadow,
        inverseSurface: inverseSurface,
        onInverseSurface: onInverseSurface,
        inversePrimary: inversePrimary,
      );
}
