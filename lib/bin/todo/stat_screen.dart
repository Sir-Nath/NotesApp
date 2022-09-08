import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../src/bloc/todo/todo_cubit.dart';


class TodoStatScreen extends StatelessWidget {
  const TodoStatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = context.read<TodoCubit>();

    var createdTasks = homeCtrl.getTotalTask();
    var completedTasks = homeCtrl.getTotalDoneTask();
    var liveTasks = createdTasks - completedTasks;
    var percent = (completedTasks / createdTasks * 100).toStringAsFixed(0);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        const Text(
          'My Report',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          DateFormat.yMMMMd()
              .format(DateTime.now()), //this format ur current date
          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
          child: Divider(
            thickness: 1.5,
          ),
        ),
        GridView(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.0,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 12.0,
          ),
          children: [
            _buildStatus(context, Colors.green, liveTasks, 'Live Tasks',
                MdiIcons.checkboxBlankOutline),
            _buildStatus(context, Colors.orange, completedTasks, 'Completed',
                MdiIcons.check),
            _buildStatus(context, Colors.blue, createdTasks, 'Created',
                MdiIcons.fileDocument),
          ],
        ),
        const SizedBox(
          height: 40.0,
        ),
        UnconstrainedBox(
          child: SizedBox(
            width: 150.0,
            height: 150.0,
            child: CircularStepProgressIndicator(
              totalSteps: createdTasks == 0 ? 1 : createdTasks,
              currentStep: completedTasks,
              stepSize: 12,
              selectedColor: Colors.green,
              unselectedColor: Colors.grey[200],
              padding: 0,
              width: 200,
              height: 200,
              selectedStepSize: 12,
              roundedCap: (_, __) => true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${createdTasks == 0 ? 0 : percent} %',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      )),
                  const SizedBox(height: 1.0),
                  const Text(
                    'Efficiency',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildStatus(
    BuildContext context,
    Color color,
    int number,
    String text,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: color,
            child: Padding(
              padding: const EdgeInsets.all(2.5),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                '$number tasks',
                style: const TextStyle(color: Colors.grey, fontSize: 10.0),
              )
            ],
          )
        ],
      ),
    );
    // Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Container(
    //       height: 3.0,
    //       width: 3.0,
    //       decoration: BoxDecoration(
    //           shape: BoxShape.circle,
    //           border: Border.all(width: 0.5, color: color)),
    //     ),
    //     const SizedBox(
    //       width: 3.0,
    //     ),
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           '$number ',
    //           style:
    //               const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
    //         ),
    //         const SizedBox(height: 2.0),
    //         Text(
    //           text,
    //           style: const TextStyle(color: Colors.grey, fontSize: 12.0),
    //         )
    //       ],
    //     )
    //   ],
    // );
  }
}
