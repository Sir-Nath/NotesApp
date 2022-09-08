import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/utilities/functions/shortcuts.dart';
import '../../../bloc/todo/todo_cubit.dart';
import '../../../bloc/todo/todo_state.dart';

class DoingList extends StatelessWidget {
  const DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    return BlocProvider<TodoCubit>.value(
      value: context.watch<TodoCubit>(),
      child: BlocBuilder<TodoCubit, TodoState>(
        bloc: context.watch<TodoCubit>(),
        builder: (context, state) {
          return state.doingTodos.isEmpty && state.doneTodos.isEmpty
              ? const Column(
                  children: [
                    // Icon(Icons),
                    Text(
                      'Add Task',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Checklist (${state.doingTodos.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        ...state.doingTodos.map(
                          (element) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: getAppColorScheme(context).secondary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[100]!.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 2,
                                    ),
                                  ]),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => getAppColorScheme(context)
                                            .onSecondary,
                                      ),
                                      value: element['done'],
                                      onChanged: (value) {
                                        todoCubit.doneTodo(
                                          element['title'],
                                        ); //this is where we add our todo into done
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    element['title'],
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: getAppColorScheme(context)
                                          .onSecondary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (state.doingTodos.isNotEmpty)
                          const Divider(
                            thickness: 1,
                          )
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}
