import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notes/src/bloc/todo/todo_state.dart';

import '../../model/todo/task_model.dart';

class TodoCubit extends HydratedCubit<TodoState> {
  TodoCubit() : super(TodoState.initial());

  void changeTabIndex(int index) {
    emit(state.copyWith(
      tabIndex: index,
    ));
  }

  void changeChipIndex(int value) {
    emit(state.copyWith(
      chipIndex: value,
    ));
  }

  bool addTask(Task task) {
    if (state.tasks.contains(task)) {
      return false;
    }
    emit(state.copyWith(
      tasks: [...state.tasks, task],
    ));
    return true;
  }

  void deleteTask(Task task) {
    emit(state.copyWith(
      tasks: state.tasks..remove(task),
    ));
  }

  void changeDeleting(bool value) {
    emit(state.copyWith(
      deleting: value,
    ));
  }

  void changeTask(Task? task) {
    emit(state.copyWith(
      task: task,
    ));
  }

  void changeTodos(List<Map<String, dynamic>> tasks) {
    state.copyWith(doneTodos: [], doingTodos: []);

    for (var task in tasks) {
      if (task['done']) {
        state.copyWith(
          doneTodos: [...state.doneTodos, task],
        );
      } else {
        state.copyWith(
          doingTodos: [...state.doingTodos, task],
        );
      }
    }
    emit(state.copyWith(
      doneTodos: state.doneTodos,
      doingTodos: state.doingTodos,
    ));
  }

  bool containTodo(List todos, String title) {
    return todos.any((todo) => todo['title'] == title);
  }

  updateTask(Task? task, String text) {
    final todos = state.task.todos;
    if (containTodo(todos, text)) {
      return false;
    }
    final todo = {
      'title': text,
      'done': false,
    };
    todos.add(todo);
    final newTask = state.task.copyWith(
      todos: todos,
    );
    emit(state.copyWith(task: newTask));
    int oldIndex = state.tasks.indexOf(task!);

    state.tasks[oldIndex] = newTask;
    emit(state.copyWith(
      tasks: state.tasks,
    ));
    return true;
  }

  bool addTodo(String title) {
    final todo = {
      'title': title,
      'done': false,
    };
    if (state.doingTodos.any((element) => mapEquals(todo, element))) {
      return false;
    }

    final doneTodo = {
      'title': title,
      'done': true,
    };

    if (state.doneTodos.any((element) => mapEquals(doneTodo, element))) {
      return false;
    }

    emit(
      state.copyWith(
        doingTodos: [...state.doingTodos, todo],
        task: state.task.copyWith(
          todos: [...state.task.todos, todo],
        ),
      ),
    );
    return true;
  }

  void updateTodos() {
    final newTodos = <Map<String, dynamic>>[];

    newTodos.addAll([...state.doingTodos, ...state.doneTodos]);

    final newTask = state.task.copyWith(
      todos: newTodos,
    );
    emit(state.copyWith(task: newTask));

    int oldIndex = state.tasks.indexWhere((e) => e.title == state.task.title);
    state.tasks[oldIndex].copyWith(
      todos: newTask.todos,
      title: newTask.title,
      icon: newTask.icon,
      color: newTask.color,
    );
    emit(state.copyWith(
      tasks: state.tasks,
      task: newTask,
    ));
  }

  void doneTodo(String title) {
    // final index =
    //     state.doingTodos.indexWhere((element) => element['title'] == title);
    // List<Map<String, dynamic>> tempList = state.doingTodos;
    state.doingTodos.removeWhere((element) => element['title'] == title);
    // state.doingTodos.removeAt(index);
    final todo = {
      'title': title,
      'done': true,
    };
    // state.copyWith(
    //   doneTodos: [...state.doneTodos, todo],
    // );
    emit(state.copyWith(
      doingTodos: [...state.doingTodos],
      doneTodos: [...state.doneTodos, todo],
    ));
  }

  void deleteDoneTodo(Map<String, dynamic> doneTodo) {
    final index =
        state.doneTodos.indexWhere((element) => mapEquals(doneTodo, element));

    state.doneTodos.removeAt(index);
    emit(state.copyWith(
      doneTodos: state.doneTodos ,
    ));
  }

  bool isTodoEmpty(Task task) {
    return task.todos.isEmpty;
  }

  int getDoneTodo(Task task) {
    return task.todos.length - state.doneTodos.length;
  }

  int getTotalTask() {
    return state.tasks.length;
  }

  int getTotalDoneTask() {
    int totalDoneTask = 0;
    for (var task in state.tasks) {
      if (task.todos.length == state.doneTodos.length) {
        totalDoneTask++;
      }
    }
    return totalDoneTask;
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    return TodoState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    return state.toMap();
  }
}
