import 'package:get/get.dart';

import '../../data/providers/task/provider.dart';
import '../../data/services/storage/repository.dart';
import 'controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        taskRepository: TaskRepository(
          taskProvider: TaskProvider(),
        ),
      ),
    );
  }
}
