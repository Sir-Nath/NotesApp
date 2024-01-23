import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../src/bloc/app/app_cubit.dart';
import '../../../src/utilities/functions/shortcuts.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    super.key,
    required this.mode,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final ThemeMode mode;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (p, c) => p.theme != c.theme,
      builder: (context, state) {
        return Card(
          elevation: 0,
          color: state.theme.mode == mode ? getCustomOnPrimaryColor(context) : getPrimaryColor(context),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            child: Icon(
              icon,
              size: 28,
              color: state.theme.mode != mode ? getTheme(context).primary : Colors.white,
            ),
          ),
        );
      },
    );
  }
}
