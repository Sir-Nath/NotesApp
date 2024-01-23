import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../src/bloc/app/app_cubit.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.destinations,
    required this.currentPageIndex,
  });

  final List<Widget> destinations;
  final int currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: NavigationBar(
        height: 60,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) => 
            context.read<AppCubit>().changePageIndex(index: index),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: destinations,
      ),
    );
  }
}
