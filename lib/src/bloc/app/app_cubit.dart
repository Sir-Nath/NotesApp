import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_model.dart';
part 'app_state.dart';

class AppCubit extends HydratedCubit<AppState> {
  AppCubit() : super(AppState.initial());

  void changePageIndex({required int index}) => emit(
        state.copyWith(
          pageIndex: index,
        ),
      );

  createThemeModel() async {
    ThemeModel.create();
    emit(state.copyWith(theme:  ThemeModel.create()));
  }

  Future<void> setThemeMode({required ThemeMode mode}) async {
    late ThemeModel theme;
    if (mode == ThemeMode.system) {
      theme = ThemeModel(
        mode: ThemeMode.system,
        light: createTheme(brightness: Brightness.light),
        dark: createTheme(brightness: Brightness.dark),
      );
      emit(state.copyWith(theme: theme));
      updateSystemOverlay();
    } else if (mode == ThemeMode.light) {
      theme = ThemeModel(
        mode: ThemeMode.light,
        light: createTheme(brightness: Brightness.light),
        dark: state.theme.dark,
      );
    } else {
      theme = ThemeModel(
        mode: ThemeMode.dark,
        light: state.theme.light,
        dark: createTheme(brightness: Brightness.dark),
      );
    }

    emit(state.copyWith(
      theme: theme,
    ));
    updateSystemOverlay();
  }

  Future<void> setThemeColor({required Color color}) async {
    final theme = ThemeModel(
      mode: state.theme.mode,
      light: createTheme(color: color, brightness: Brightness.light),
      dark: createTheme(color: color, brightness: Brightness.dark),
    );

    emit(state.copyWith(theme: theme));
    updateSystemOverlay();
  }

  void updateSystemOverlay() {
    final systemModeIsDark =
        SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

    final isDark = state.theme.mode == ThemeMode.system
        ? systemModeIsDark
        : state.theme.mode == ThemeMode.dark;
    final colorScheme =
        isDark ? state.theme.dark.colorScheme : state.theme.light.colorScheme;
    final primaryColor = ElevationOverlay.colorWithOverlay(
      colorScheme.surface,
      colorScheme.primary,
      3,
    );

    SystemChrome.setSystemUIOverlayStyle(
      createOverlayStyle(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: primaryColor,
      ),
    );
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    final theme = ThemeModel.fromJson(json['theme'] as Map<String, dynamic>);

    return AppState(
      pageIndex: 0,
      theme: theme,
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {
      'theme': state.theme.toJson(),
    };
  }
}
