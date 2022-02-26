import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/text_styles.dart';
import '../../../core/values/constants.dart';
import '../../../data/models/task.dart';
import '../../../widgets/easy_loading_manager.dart';
import '../controller.dart';

class AddDialog extends StatelessWidget {
  final _controller = Get.find<HomeController>();
  AddDialog({Key? key}) : super(key: key);

  void _processClose() {
    Get.back();

    //* Clear cache
    _controller.editController.clear();
    _controller.changeTask(null);
  }

  void _processAddToto() {
    if (_controller.formKey.currentState!.validate()) {
      if (_controller.task.value == null) {
        EasyLoadingManager.showError(
          status: 'Please select task type',
        );
      } else {
        final result = _controller.updateTask(
          _controller.task.value!,
          _controller.editController.text,
        );

        if (result) {
          EasyLoadingManager.showSuccess(
            status: 'Todo item add success',
          );
          Get.back();
          _controller.changeTask(null);
        } else {
          EasyLoadingManager.showError(
            status: 'Todo item already exist',
          );
        }
        _controller.editController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _controller.formKey,
        child: ListView(
          children: [
            _buildTopNav(),
            const SizedBox(height: kDefaultSpacing),
            _buildTitle(),
            _buildInputText(),
            _buildAddToTitle(),
            ..._controller.tasks.map((task) {
              return _buildItem(task);
            }).toList(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _processClose,
            icon: const Icon(Icons.close),
          ),
          TextButton(
            onPressed: _processAddToto,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Text(
              'Add',
              style: buttonStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
      ),
      child: Text(
        'New Task',
        style: titleNormalStyle,
      ),
    );
  }

  Widget _buildInputText() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
      ),
      child: TextFormField(
        controller: _controller.editController,
        autofocus: true,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[400]!,
            ),
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

  Widget _buildAddToTitle() {
    return Padding(
      padding: const EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        bottom: kDefaultPadding,
        top: kDefaultPadding * 2,
      ),
      child: Text(
        'Add to',
        style: buttonStyle.copyWith(color: Colors.grey),
      ),
    );
  }

  Widget _buildItem(Task task) {
    return Obx(() {
      return InkWell(
        onTap: () => _controller.changeTask(task),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding,
          ),
          child: Row(
            children: [
              Icon(
                IconData(task.icon, fontFamily: 'MaterialIcons'),
                color: HexColor.fromHex(task.color),
              ),
              const SizedBox(width: kDefaultSpacing),
              Text(task.title, style: titleItemStyle),
              const Spacer(),
              if (_controller.task.value == task)
                const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
            ],
          ),
        ),
      );
    });
  }
}
