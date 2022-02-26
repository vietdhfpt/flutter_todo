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

  void _openDetailPage() {
    _homeController.changeTask(task);
    _homeController.changeTodos(task.todos ?? []);
    Get.to(() => DetailPage());
  }

  @override
  Widget build(BuildContext context) {
    final color = HexColor.fromHex(task.color);
    final squareWidth = Get.width - kDefaultPadding * 3;

    return GestureDetector(
      onTap: _openDetailPage,
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
            _buildStepProgress(color),
            _buildIcon(color),
            _buildTextInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepProgress(Color color) {
    return StepProgressIndicator(
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
    );
  }

  Widget _buildIcon(Color color) {
    return Padding(
      padding: EdgeInsets.all(6.0.wp),
      child: Icon(
        IconData(
          task.icon,
          fontFamily: 'MaterialIcons',
        ),
        color: color,
      ),
    );
  }

  Widget _buildTextInfo() {
    return Padding(
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
    );
  }
}
