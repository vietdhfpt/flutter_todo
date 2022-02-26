import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../core/utils/extensions.dart';
import '../../core/utils/text_styles.dart';
import '../../core/values/colors.dart';
import '../../core/values/constants.dart';
import '../home/controller.dart';

class ReportPage extends StatelessWidget {
  final _controller = Get.find<HomeController>();
  ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          var createdTasks = _controller.getTotalTask();
          var completedTasks = _controller.getTotalDoneTask();
          var liveTasks = createdTasks - completedTasks;
          var percent =
              (completedTasks / createdTasks * 100).toStringAsFixed(0);

          return ListView(
            children: [
              _buildTitle(),
              _buildUpdatedTime(),
              _buildSeperator(),
              _buildListStatus(liveTasks, completedTasks, createdTasks),
              SizedBox(height: 8.0.wp),
              _buildCircularProgress(createdTasks, completedTasks, percent),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(
        top: kDefaultPadding,
        left: kDefaultPadding,
        right: kDefaultPadding,
      ),
      child: Text('My Report', style: titleBigStyle),
    );
  }

  Widget _buildUpdatedTime() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Text(
        DateFormat.yMMMMd().add_Hm().format(DateTime.now()),
        style: normalStyle.copyWith(color: Colors.grey),
      ),
    );
  }

  Widget _buildSeperator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Divider(thickness: 2),
    );
  }

  Widget _buildListStatus(int liveTasks, int completedTasks, int createdTasks) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 3.0.wp,
        horizontal: 5.0.wp,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatus(
            Colors.green,
            liveTasks,
            'Live Tasks',
          ),
          _buildStatus(
            Colors.orange,
            completedTasks,
            'Completed',
          ),
          _buildStatus(
            Colors.blue,
            createdTasks,
            'Created',
          ),
        ],
      ),
    );
  }

  Widget _buildStatus(Color color, int number, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(height: 1.0.hp),
            Container(
              height: 3.0.wp,
              width: 3.0.wp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 0.5.wp, color: color),
              ),
            ),
          ],
        ),
        SizedBox(width: 3.0.wp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0.sp,
              ),
            ),
            SizedBox(height: 2.0.wp),
            Text(
              title,
              style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularProgress(
    int createdTasks,
    int completedTasks,
    String percent,
  ) {
    return UnconstrainedBox(
      child: SizedBox(
        width: 70.0.wp,
        height: 70.0.wp,
        child: CircularStepProgressIndicator(
          totalSteps: createdTasks == 0 ? 1 : createdTasks,
          currentStep: completedTasks,
          stepSize: 20,
          selectedColor: green,
          unselectedColor: Colors.grey[200],
          padding: 0,
          width: 150,
          height: 150,
          selectedStepSize: 22,
          roundedCap: (p0, p1) {
            return true;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${createdTasks == 0 ? 0 : percent}%',
                style: titleBigStyle,
              ),
              const SizedBox(height: kDefaultPadding / 3),
              const Text(
                'Efficiency',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
