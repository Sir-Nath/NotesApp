import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../model/todo/task_model.dart';

class TodoState extends Equatable {
  final int tabIndex;
  final int chipIndex;
  final bool deleting;
  final List<Task> tasks;
  final Task task;
  final List<Map<String, dynamic>> doingTodos;
  final List<Map<String, dynamic>> doneTodos;

  const TodoState({
    required this.tabIndex,
    required this.chipIndex,
    required this.deleting,
    required this.tasks,
    required this.task,
    required this.doingTodos,
    required this.doneTodos,
  });

  factory TodoState.initial() {
    return TodoState(
      tabIndex: 0,
      chipIndex: 0,
      deleting: false,
      tasks: const <Task>[],
      task: Task.empty(),
      doingTodos: const <Map<String, dynamic>>[],
      doneTodos: const <Map<String, dynamic>>[],
    );
  }

  TodoState copyWith({
    int? tabIndex,
    int? chipIndex,
    bool? deleting,
    List<Task>? tasks,
    Task? task,
    List<Map<String, dynamic>>? doingTodos,
    List<Map<String, dynamic>>? doneTodos,
  }) {
    return TodoState(
      tabIndex: tabIndex ?? this.tabIndex,
      chipIndex: chipIndex ?? this.chipIndex,
      deleting: deleting ?? this.deleting,
      tasks: tasks ?? this.tasks,
      task: task ?? this.task,
      doingTodos: doingTodos ?? this.doingTodos,
      doneTodos: doneTodos ?? this.doneTodos,
    );
  }

  @override
  String toString() {
    return 'TodoState(tabIndex: $tabIndex, chipIndex: $chipIndex, deleting: $deleting, tasks: $tasks, task: $task, doingTodos: $doingTodos, doneTodos: $doneTodos)';
  }

  @override
  List<Object?> get props => [
        tabIndex,
        chipIndex,
        deleting,
        tasks,
        task,
        doingTodos,
        doneTodos,
      ];

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'tabIndex': tabIndex});
    result.addAll({'chipIndex': chipIndex});
    result.addAll({'deleting': deleting});
    result.addAll({'tasks': tasks.map((x) => x.toMap()).toList()});
    result.addAll({'task': task.toMap()});
    result.addAll({'doingTodos': doingTodos});
    result.addAll({'doneTodos': doneTodos});

    return result;
  }

  factory TodoState.fromMap(Map<String, dynamic> map) {
    return TodoState(
      tabIndex: map['tabIndex']?.toInt() ?? 0,
      chipIndex: map['chipIndex']?.toInt() ?? 0,
      deleting: map['deleting'] ?? false,
      tasks: List<Task>.from(map['tasks']?.map((x) => Task.fromMap(x))),
      task: Task.fromMap(map['task']),
      doingTodos: List<Map<String, dynamic>>.from(map['doingTodos']),
      doneTodos: List<Map<String, dynamic>>.from(map['doneTodos']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoState.fromJson(String source) =>
      TodoState.fromMap(json.decode(source));
}
