import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';

import 'app_theme.dart';

class ThemeModel extends Equatable {
  final ThemeMode mode;
  final ThemeData light;
  final ThemeData dark;

  const ThemeModel({
    required this.mode,
    required this.light,
    required this.dark,
  });

  factory ThemeModel.initial() => ThemeModel(
        mode: ThemeMode.system,
        light: ThemeData.light(),
        dark: ThemeData.dark(),
      );

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    try {
      final mode = json['mode'] as int;
      final light = json['light'] as Map<String, dynamic>;
      final dark = json['dark'] as Map<String, dynamic>;

      return ThemeModel(
        mode: ThemeMode.values.elementAt(mode),
        light: ThemeDecoder.decodeThemeData(light, validate: false)!,
        dark: ThemeDecoder.decodeThemeData(dark, validate: false)!,
      );
    } catch (e) {
      return ThemeModel.initial();
    }
  }

  Map<String, dynamic> toJson() => {
        'mode': mode.index,
        'light': ThemeEncoder.encodeThemeData(light),
        'dark': ThemeEncoder.encodeThemeData(dark),
      };

  @factory
  static ThemeModel create()  {
    return ThemeModel(
        mode: ThemeMode.system,
        light:  createTheme(brightness: Brightness.light),
        dark:  createTheme(brightness: Brightness.dark));
  }

  ThemeModel copyWith({
    ThemeMode? mode,
    ThemeData? light,
    ThemeData? dark,
  }) {
    return ThemeModel(
      mode: mode ?? this.mode,
      light: light ?? this.light,
      dark: dark ?? this.dark,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        light,
        dark,
      ];
}
