import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/bloc/todo/todo_cubit.dart';
import '../../../bloc/todo/todo_state.dart';
import '../../../utilities/functions/shortcuts.dart';

class DoneList extends StatelessWidget {
  const DoneList({super.key});

  @override
  Widget build(BuildContext context) {
    // final state = context.watch<TodoCubit>().state;
    final todoCubit = context.read<TodoCubit>();

    return BlocProvider<TodoCubit>.value(
      value: BlocProvider.of<TodoCubit>(context),
      child: BlocBuilder<TodoCubit, TodoState>(builder: (context, state) {
        return state.doneTodos.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const ClampingScrollPhysics(),
                children: [
                  Text(
                    'Completed (${state.doneTodos.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ...state.doneTodos.map((element) => Dismissible(
                        key: ObjectKey(element),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => todoCubit.deleteDoneTodo(element),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16.0,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
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
                          child: Row(children: [
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: Icon(
                                Icons.check_box_outlined,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              element['title'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: getAppColorScheme(context).onSecondary,
                                decoration: TextDecoration.lineThrough,
                                decorationColor:
                                    getAppColorScheme(context).secondary,
                                decorationThickness: 5,
                              ),
                            )
                          ]),
                        ),
                      ))
                ],
              )
            : Container();
      }),
    );
  }
}
