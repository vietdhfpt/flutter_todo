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

  void clearCache() {
    editController.clear();
    changeChipIndex(0);
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
}
