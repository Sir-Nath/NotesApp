import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:notes/src/view/widget/theme_card.dart';
import 'package:spring_button/spring_button.dart';

import '../../../src/bloc/app/app_cubit.dart';
import '../../../src/theme/color_const.dart';
import '../../../src/utilities/functions/shortcuts.dart';

final PageController pageController = PageController();

class ThemeCustomizer extends StatelessWidget {
  const ThemeCustomizer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const SizedBox(height: 8),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2 / 1,
          padding: EdgeInsets.zero,
          children: [
            ThemeCard(
              mode: ThemeMode.system,
              icon: MdiIcons.brightnessAuto,
              onTap: () =>
                 context.read<AppCubit>().setThemeMode(mode: ThemeMode.system),
            ),
            ThemeCard(
              mode: ThemeMode.light,
              icon: MdiIcons.brightness7,
              onTap: () =>
                 context.read<AppCubit>().setThemeMode(mode: ThemeMode.light),
            ),
            ThemeCard(
              mode: ThemeMode.dark,
              icon: MdiIcons.brightness1,
              onTap: () =>context.read<AppCubit>().setThemeMode(mode: ThemeMode.dark),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<AppCubit, AppState>(
          buildWhen: (p, c) => p.theme.mode != c.theme.mode,
          builder: (context, state) {
            final disabled = state.theme.mode == ThemeMode.system;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: getTheme(context).primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        MdiIcons.palette,
                        color: getTheme(context).background,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: screenWidth - 92,
                      child: ListView.builder(
                        itemCount: constants.theme.themeColors.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return buildColor(index: index, disabled: disabled, context: context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildColor({required int index, required bool disabled, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(left: index != 0 ? 8 : 0),
      child: SpringButton(
        SpringButtonType.OnlyScale,
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: !disabled
                ? constants.theme.themeColors.elementAt(index)
                : constants.theme.themeColors.elementAt(index).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
        onTap: !disabled
            ? () => context.read<AppCubit>().setThemeColor(
                  color: constants.theme.themeColors.elementAt(index),
                )
            : null,
        useCache: false,
        scaleCoefficient: 0.9,
      ),
    );
  }
}

class SelectedColor extends StatelessWidget {
  const SelectedColor(
      {super.key, required this.selectedColor, this.icon, this.iconColor});
  final Color selectedColor;
  final IconData? icon;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: selectedColor,
        shape: BoxShape.circle,
      ),
      child: icon != null
          ? Icon(
              icon,
              color: iconColor,
              size: 22,
            )
          : null,
    );
  }
}
