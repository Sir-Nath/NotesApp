import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:notes/src/bloc/todo/todo_cubit.dart';
import 'package:notes/src/utilities/functions/shortcuts.dart';
import 'package:notes/src/view/todo/widget/doing_list.dart';
import 'package:notes/src/view/todo/widget/done_list.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../bloc/todo/todo_state.dart';
import '../../constants/extension/color.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final homeCtrl = context.watch<TodoCubit>().state;
    final todoCubit = context.watch<TodoCubit>();
    final task = homeCtrl.task;
    final color = HexColor.fromHex(task.color);
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                  todoCubit.updateTodos(); //we update our note on going back
                  todoCubit.changeTask(null);
                  todoController.clear();
                },
                icon: Icon(MdiIcons.logout),
              ),
              title: const Text(
                'Task Detail',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                final totalTodos =
                    state.doingTodos.length + state.doneTodos.length;

                return Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              IconData(task.icon, fontFamily: 'MaterialIcons'),
                              color: color,
                            ),
                            const SizedBox(
                              width: 3.0,
                            ),
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 3.0, right: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$totalTodos  Tasks',
                              style: const TextStyle(
                                  fontSize: 12.0, color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                                child: StepProgressIndicator(
                              totalSteps: totalTodos == 0 ? 1 : totalTodos,
                              currentStep: state.doneTodos.length,
                              size: 5,
                              padding: 0,
                              selectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [color.withOpacity(0.5), color]),
                              unselectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey[300]!,
                                    Colors.grey[300]!
                                  ]),
                            ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 16.0),
                        child: TextFormField(
                          controller: todoController,
                          focusNode: todoFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                              hintText: 'input your task here...',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[400]!,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.task_alt_outlined,
                                color: Colors.grey[400],
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    var success =
                                        todoCubit.addTodo(todoController.text);
                                    if (success) {
                                      EasyLoading.showSuccess(
                                          'Todo item add success');
                                    } else {
                                      EasyLoading.showError(
                                          'Todo item already exist');
                                    }
                                    todoController.clear();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(
                                    left: 5.0,
                                    bottom: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getAppColorScheme(context).primary,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    color: getAppColorScheme(context).onPrimary,
                                  ),
                                ),
                              )),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your todo item';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const DoingList(),
                      const DoneList()
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  final TextEditingController todoController = TextEditingController();
  final FocusNode todoFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}
