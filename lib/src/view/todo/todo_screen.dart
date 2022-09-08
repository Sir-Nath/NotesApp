import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/bloc/todo/todo_cubit.dart';
import 'package:notes/src/view/todo/stat_screen.dart';
import 'package:notes/src/view/todo/todo_home.dart';

import '../../utilities/functions/shortcuts.dart';
import '../widget/custom_segmented_control.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  PageController controller = PageController();
  int currentPage = 0;

  @override
  void initState() {
    controller.addListener(() {
      controller.addListener(() {
        if (controller.page!.round() != currentPage) {
          setState(() {
            currentPage = controller.page!.round();
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      physics: const BouncingScrollPhysics(),
      children: [
        Align(
          alignment: Alignment.center,
          child: CustomSegmentedControl<int>(
            fixedWidth: 120,
            currentIndex: currentPage,
            children: {
              0: Text(
                'Todos',
                style: getTextTheme(context).titleMedium?.copyWith(
                      color: currentPage == 0
                          ? getAppColorScheme(context).onPrimary
                          : getAppColorScheme(context).primary,
                    ),
              ),
              1: Text('Stat',
                  style: getTextTheme(context).titleMedium?.copyWith(
                        color: currentPage == 1
                            ? getAppColorScheme(context).onPrimary
                            : getAppColorScheme(context).primary,
                      )),
            },
            onValueChanged: (value) {
              controller.animateToPage(
                value,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: PageView(
            controller: controller,
            children: [
              BlocProvider<TodoCubit>.value(
                value: BlocProvider.of<TodoCubit>(context),
                child: const TodoHomeScreen(),
              ),
              BlocProvider<TodoCubit>.value(
                value: BlocProvider.of<TodoCubit>(context),
                child: const TodoStatScreen(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
