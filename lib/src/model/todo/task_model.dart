import 'dart:convert';

import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final int icon;
  final String color;
  final List<Map<String, dynamic>> todos;

  const Task({
    required this.color,
    required this.title,
    required this.icon,
    this.todos = const <Map<String, dynamic>>[],
  });

  Task copyWith({
    String? title,
    int? icon,
    String? color,
    List<Map<String, dynamic>>? todos,
  }) {
    return Task(
        title: title ?? this.title,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        todos: todos ?? this.todos);
  }

  factory Task.empty() {
    return const Task(
      title: '',
      icon: 0,
      color: '',
      todos: [],
    );
  }

  @override
  List<Object?> get props => [title, icon, color, todos];

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'icon': icon});
    result.addAll({'color': color});
    result.addAll({'todos': todos});

    return result;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      icon: map['icon']?.toInt() ?? 0,
      color: map['color'] ?? '',
      todos: map['todos'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}

//n

///This is the file for my model i.e how the content of the to-do list will be
///A to-do list is made up of 4 parameters
///I will be saving in my storage as a Json File so i will need  to;
/// convert my to-do to Json to save in storage
/// decode my to-do from json back to my model
/// copyWith allow me change a task