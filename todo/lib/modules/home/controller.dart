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
}
