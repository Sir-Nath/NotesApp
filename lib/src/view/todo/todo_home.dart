import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notes/src/bloc/todo/todo_cubit.dart';
import 'package:notes/src/constants/extension/color.dart';
import 'package:notes/src/utilities/functions/shortcuts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../bloc/todo/todo_state.dart';
import '../../model/todo/task_model.dart';
import 'detail_screen.dart';

class TodoHomeScreen extends StatelessWidget {
  const TodoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = context.read<TodoCubit>();
    // final controllerState = context.watch<TodoCubit>().state;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        BlocProvider<TodoCubit>.value(
          value: BlocProvider.of<TodoCubit>(context),
          child: BlocBuilder<TodoCubit, TodoState>(
            // buildWhen: (previous, current) {
            //   return previous.tasks != current.tasks;
            // },
            builder: (context, state) {
              return const TaskGrid();
            },
          ),
        )
      ],
    );
  }
}

class TaskGrid extends StatelessWidget {
  const TaskGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const AddCard(),
            ...state.tasks.map(
              (element) {
                return LongPressDraggable(
                  //when we map tasks from controller we get an iterable of our tasks
                  data:
                      element, //data takes the widget that will be used in Drag Target widget
                  onDragStarted: () => context.read<TodoCubit>().changeDeleting(
                      true), //this will turn the floating action  button red and dlay bin
                  onDraggableCanceled: (_, __) =>
                      context.read<TodoCubit>().changeDeleting(false),
                  onDragEnd: (_) =>
                      context.read<TodoCubit>().changeDeleting(false),
                  //feedback is what the user sees immediately he long press the widget to drag it
                  feedback: Opacity(
                    opacity: 0.8,
                    child: TaskCard(task: element),
                  ),
                  child: TaskCard(task: element),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

List<Icon> getIcons() {
  return [
    const Icon(
      Icons.work,
      color: Colors.orange,
    ),
    const Icon(
      Icons.church,
      color: Colors.purple,
    ),
    const Icon(
      Icons.self_improvement,
      color: Colors.blue,
    ),
    const Icon(
      Icons.directions_bike,
      color: Colors.green,
    ),
    const Icon(
      Icons.book,
      color: Colors.indigo,
    ),
    const Icon(
      Icons.flight,
      color: Colors.red,
    ),
    const Icon(
      Icons.shopping_cart,
      color: Colors.pink,
    ),
  ];
}

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final squareWidth = MediaQuery.of(context).size.width - 16;

    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: const EdgeInsets.all(3.0),
      child: InkWell(
        onTap: () async {
          //this is the default Dialog that comes with

          await showDialog(
              context: context,
              builder: (conext) {
                return BlocProvider.value(
                  value: context.watch<TodoCubit>(),
                  child: BlocBuilder<TodoCubit, TodoState>(
                    buildWhen: (previous, current) {
                      return previous.chipIndex != current.chipIndex;
                    },
                    builder: (context, state) {
                      return const AddTaskDialog();
                    },
                  ),
                );
              });

          taskController.clear();
          todoCubit
              .changeChipIndex(0); // we use this to reset our Choice chip index
        },
        child: DottedBorder(
          //this is a package for creating dotted border
          color: Colors.grey[400]!,
          radius: const Radius.circular(24),
          dashPattern: const [8, 4],
          borderType: BorderType.RRect,
          child: const Center(
            child: Icon(
              Icons.add,
              size: 40.0,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController taskController = TextEditingController();
  final FocusNode taskFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({
    super.key,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  @override
  Widget build(BuildContext context) {
    List<Icon> icons = getIcons();
    final todoState = context.watch<TodoCubit>().state;

    return Dialog(
      insetPadding: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Type',
              style: getTextTheme(context).bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Form(
              key:
                  formKey, //this allow us keep trade of our form state like validation
              child: Column(
                children: [
                  TextFormField(
                    controller: taskController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      // we validate the input
                      if (value == null || value.trim().isEmpty) {
                        //if we don't meet this validation criteria then we pop the error message below
                        return 'Please enter your task title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  //this the wrap of icons on the open on a dialog to add new card
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: icons.map(
                        (e) {
                          final index = icons.indexOf(e);
                          return ChoiceChip(
                            side: const BorderSide(
                              color: Colors.grey,
                            ),
                            selectedColor: Colors.grey[200],
                            pressElevation: 0,
                            backgroundColor: Colors.white,
                            label: e, //our label here is an icon
                            selected: todoState.chipIndex ==
                                index, //returns true if the selected index is same as the chipIndex valu from our controller
                            onSelected: (bool selected) {
                              context.read<TodoCubit>().changeChipIndex(
                                    selected ? index : 0,
                                  );
                              //on selected being true the index of the selected will be highlighted
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              getAppColorScheme(context).secondary),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          int icon = icons[todoState.chipIndex].icon!.codePoint;
                          String color =
                              icons[todoState.chipIndex].color!.toHex();
                          var task = Task(
                              title: taskController.text,
                              icon: icon,
                              color: color);
                          Navigator.pop(context);

                          context.read<TodoCubit>().addTask(task)
                              // todoCubit.addTask(task)
                              ? EasyLoading.showSuccess('Create Success')
                              : EasyLoading.showError('Duplicated Task');
                        }
                      },
                      child: Text(
                        'Confirm',
                        style: getTextTheme(context).bodyLarge?.copyWith(
                              color: getAppColorScheme(context).onSecondary,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController taskController = TextEditingController();
  final FocusNode taskFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}

class TaskCard extends StatelessWidget {
  final Task task; //call for Task
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final squareWidth = MediaQuery.of(context).size.width - 16;
    final color = HexColor.fromHex(task.color);
    return BlocProvider<TodoCubit>.value(
      value: BlocProvider.of<TodoCubit>(context),
      child: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              context.read<TodoCubit>().changeTask(task);
              context.read<TodoCubit>().changeTodos(task.todos);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailScreen(),
                ),
              );
            },
            child: SizedBox(
              width: squareWidth / 2,
              height: squareWidth / 2,
              child: Card(
                margin: const EdgeInsets.only(right: 3.0),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(16),
                //   color: Colors.white,
                //   boxShadow: [
                //     BoxShadow(
                //         color: Colors.grey[300]!,
                //         blurRadius: 7,
                //         offset: const Offset(0, 7))
                //   ],
                // ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                              IconData(
                                task.icon,
                                fontFamily: 'MaterialIcons',
                              ),
                              color: color),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                '${task.todos.length} Todos',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: UnconstrainedBox(
                        child: SizedBox(
                          width: 35.0,
                          height: 35.0,
                          child: CircularStepProgressIndicator(
                            totalSteps:
                                context.read<TodoCubit>().isTodoEmpty(task)
                                    ? 1
                                    : task.todos.length,
                            currentStep: context
                                    .read<TodoCubit>()
                                    .isTodoEmpty(task)
                                ? 0
                                : context.read<TodoCubit>().getDoneTodo(task),
                            stepSize: 2,
                            selectedColor: Colors.green,
                            unselectedColor: Colors.grey[200],
                            padding: 0,
                            width: 35,
                            height: 35,
                            selectedStepSize: 2,
                            roundedCap: (_, __) => true,
                            child: const Center(
                              child: Text('${75} %',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.0,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
