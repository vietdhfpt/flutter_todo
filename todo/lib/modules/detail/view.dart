import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../core/utils/extensions.dart';
import '../../core/utils/text_styles.dart';
import '../../core/values/constants.dart';
import '../../data/models/task.dart';
import '../../widgets/easy_loading_manager.dart';
import '../home/controller.dart';
import 'widgets/doing_list.dart';
import 'widgets/done_list.dart';

class DetailPage extends StatelessWidget {
  final _homeController = Get.find<HomeController>();

  DetailPage({Key? key}) : super(key: key);

  void _processBack() {
    Get.back();
    _homeController.updateTodos();
    _homeController.changeTask(null);
    _homeController.editController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final task = _homeController.task.value!;
    return Scaffold(
      body: Form(
        key: _homeController.formKey,
        child: ListView(
          children: [
            _buildTopNav(),
            const SizedBox(height: kDefaultSpacing),
            _buildHeader(task),
            _buildStatus(task),
            _buildInput(),
            DoingList(),
            DoneList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 2,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _processBack,
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
      ),
      child: Row(
        children: [
          Icon(
            IconData(
              task.icon,
              fontFamily: 'MaterialIcons',
            ),
            color: HexColor.fromHex(task.color),
            size: 30,
          ),
          const SizedBox(width: kDefaultSpacing / 2),
          Text(
            task.title,
            style: titleNormalStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStatus(Task task) {
    return Obx(() {
      var totalTodos =
          _homeController.doingTodosLength + _homeController.doneTodosLength;

      final color = HexColor.fromHex(task.color);
      return Padding(
        padding: const EdgeInsets.only(
          top: kDefaultPadding / 2,
          left: kDefaultPadding * 3.5,
          right: kDefaultPadding * 3.5,
          bottom: kDefaultPadding / 2,
        ),
        child: Row(
          children: [
            Text(
              '$totalTodos Tasks',
              style: normalStyle.copyWith(
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(width: kDefaultSpacing),
            Expanded(
              child: StepProgressIndicator(
                totalSteps: totalTodos == 0 ? 1 : totalTodos,
                currentStep: _homeController.doneTodosLength,
                size: 5,
                padding: 0,
                selectedGradientColor: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.5), color],
                ),
                unselectedColor: Colors.grey[300]!,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 2,
        vertical: kDefaultPadding,
      ),
      child: TextFormField(
        controller: _homeController.editController,
        autofocus: true,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          prefixIcon: Icon(
            Icons.check_box_outline_blank,
            color: Colors.grey[400],
          ),
          suffixIcon: IconButton(
            onPressed: () {
              if (_homeController.formKey.currentState!.validate()) {
                var success = _homeController.addTodo(
                  _homeController.editController.text,
                );
                if (success) {
                  EasyLoadingManager.showSuccess(
                    status: 'Todo item add success',
                  );
                } else {
                  EasyLoadingManager.showError(
                    status: 'Todo item already exist',
                  );
                }
                _homeController.editController.clear();
              }
            },
            icon: const Icon(Icons.done),
            color: Colors.grey[400],
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your todo item';
          }
          return null;
        },
      ),
    );
  }
}
