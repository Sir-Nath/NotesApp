import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/view/widget/bottom_navigation.dart';

import '../bloc/app/app_cubit.dart';
import '../constants/navigation.dart';
import '../constants/routes/route.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  Widget build(BuildContext context) {
    Navigation navigation = Navigation();
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return Scaffold(
        floatingActionButton: state.pageIndex == 1
            ? null
            : FloatingActionButton(
                onPressed: () {
                  if (state.pageIndex == 0) {
                    Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                  }
                },
                child: const Icon(Icons.add),
              ),
        appBar: navigation.appbars(context).elementAt(state.pageIndex),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:
              navigation.bottomNavigationScreens(context).elementAt(state.pageIndex),
        ),
        bottomNavigationBar: BottomNavigation(
          destinations: navigation.bottomNavigationItems(context),
          currentPageIndex: state.pageIndex,
        ),
      );
    });
  }
}
