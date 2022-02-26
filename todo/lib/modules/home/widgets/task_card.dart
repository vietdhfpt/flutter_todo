import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/text_styles.dart';
import '../../../core/values/constants.dart';
import '../../../data/models/task.dart';
import '../../detail/view.dart';
import '../controller.dart';

class TaskCard extends StatelessWidget {
  final _homeController = Get.find<HomeController>();
  final Task task;

  TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = HexColor.fromHex(task.color);
    final squareWidth = Get.width - kDefaultPadding * 3;
    return GestureDetector(
      onTap: () {
        _homeController.changeTask(task);
        _homeController.changeTodos(task.todos ?? []);
        Get.to(() => DetailPage());
      },
      child: Container(
        width: squareWidth / 2,
        height: squareWidth / 2,
        decoration: BoxDecoration(
          boxShadow: [appShadow],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepProgressIndicator(
              totalSteps: 100,
              currentStep: 80,
              size: 5,
              padding: 0,
              selectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.5), color],
              ),
              unselectedGradientColor: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0.wp),
              child: Icon(
                IconData(
                  task.icon,
                  fontFamily: 'MaterialIcons',
                ),
                color: color,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: titleItemStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: kDefaultSpacing / 2),
                  Text(
                    '${task.todos?.length ?? 0} Task',
                    style: normalStyle.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
