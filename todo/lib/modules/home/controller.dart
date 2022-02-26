import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/task.dart';
import '../../data/services/storage/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});

  final editController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final chipIndex = 0.obs;
  final _isDeleting = false.obs;
  bool get isDeleting => _isDeleting.value;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;
  int get doingTodosLength => doingTodos.length;
  int get doneTodosLength => doneTodos.length;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    editController.dispose();
    super.onClose();
  }

  void changeChipIndex(int value) {
    chipIndex(value);
  }

  void changeDeleting(bool value) {
    _isDeleting(value);
  }

  void changeTask(Task? newTask) {
    task(newTask);
  }

  void changeTodos(List<dynamic> newTodos) {
    doingTodos.clear();
    doneTodos.clear();

    for (int i = 0; i < newTodos.length; i++) {
      var todo = newTodos[i];
      var status = todo['done'];
      if (status) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }

    tasks.add(task);
    return true;
  }

  bool deleteTask(Task task) {
    return tasks.remove(task);
  }

  bool updateTask(
    Task task,
    String title,
  ) {
    var todos = task.todos ?? [];
    if (containsTodo(todos, title)) {
      return false;
    }

    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldTaskIndex = tasks.indexOf(task);
    tasks[oldTaskIndex] = newTask;
    tasks.refresh();
    return true;
  }

  bool containsTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  bool addTodo(String title) {
    var todo = {'title': title, 'done': false};
    if (doingTodos.any((e) => mapEquals<String, dynamic>(todo, e))) {
      return false;
    }

    var doneTodo = {'title': title, 'done': true};
    if (doneTodos.any((e) => mapEquals<String, dynamic>(doneTodo, e))) {
      return false;
    }

    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);
    var newTask = task.value!.copyWith(todos: newTodos);
    var oldTaskIndex = tasks.indexOf(task.value);
    tasks[oldTaskIndex] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere((element) {
      return mapEquals<String, dynamic>(doingTodo, element);
    });
    doingTodos.removeAt(index);
    doingTodos.refresh();

    var doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo);
    doneTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    doneTodos.remove(doneTodo);
  }

  bool isTodosEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done']) {
        res += 1;
      }
    }
    return res;
  }
}
