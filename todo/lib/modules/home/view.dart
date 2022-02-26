import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/text_styles.dart';
import '../../core/values/constants.dart';
import '../../data/models/task.dart';
import '../../widgets/easy_loading_manager.dart';
import 'controller.dart';
import 'widgets/add_card.dart';
import 'widgets/add_dialog.dart';
import 'widgets/task_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  void _processAddTask() {
    if (controller.tasks.isNotEmpty) {
      Get.to(
        () => AddDialog(),
        transition: Transition.downToUp,
      );
    } else {
      EasyLoadingManager.showInfo(status: 'Please create your task type');
    }
  }

  void _processDeleteTask(Task task) {
    controller.deleteTask(task)
        ? EasyLoadingManager.showSuccess(status: 'Delete success')
        : EasyLoadingManager.showError(status: 'Delete unsuccess');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Text('My List', style: titleBigStyle),
                  ),
                  Obx(() {
                    return GridView.count(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      mainAxisSpacing: kDefaultPadding,
                      crossAxisSpacing: kDefaultPadding,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ...controller.tasks.map((task) {
                          return _buildItem(task);
                        }),
                        AddCard(),
                      ],
                    );
                  }),
                ],
              ),
            ),
            if (controller.isDeleting) _buildOpacity(),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildDeleteButton(),
    );
  }

  Widget _buildOpacity() {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.black.withOpacity(0.4),
    );
  }

  Widget _buildItem(Task task) {
    return LongPressDraggable(
      data: task,
      onDragStarted: () {
        controller.changeDeleting(true);
      },
      onDragEnd: (_) {
        controller.changeDeleting(false);
      },
      onDraggableCanceled: (velocity, offset) {
        controller.changeDeleting(false);
      },
      feedback: Opacity(
        opacity: 0.85,
        child: TaskCard(task: task),
      ),
      child: TaskCard(task: task),
    );
  }

  Widget _buildDeleteButton() {
    return DragTarget<Task>(
      builder: (context, _, __) {
        return Obx(() {
          return FloatingActionButton(
            onPressed: _processAddTask,
            backgroundColor: controller.isDeleting ? Colors.red : Colors.blue,
            child: Icon(
              controller.isDeleting ? Icons.delete : Icons.add,
            ),
          );
        });
      },
      onAccept: (Task task) => _processDeleteTask(task),
    );
  }
}
