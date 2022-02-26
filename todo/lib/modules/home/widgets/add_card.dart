import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/values/colors.dart';
import '../../../core/values/constants.dart';
import '../../../data/models/task.dart';
import '../../../widgets/easy_loading_manager.dart';
import '../../../widgets/icons.dart';
import '../controller.dart';

class AddCard extends StatelessWidget {
  final _controller = Get.find<HomeController>();

  AddCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    final squareWidth = Get.width - kDefaultPadding * 3;

    return SizedBox(
      width: squareWidth / 2,
      height: squareWidth / 2,
      child: InkWell(
        onTap: () {
          Get.defaultDialog(
            titlePadding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding,
            ),
            radius: kDefaultBorderRadius,
            title: 'Task Type',
            content: Form(
              key: _controller.formKey,
              child: Column(
                children: [
                  _buildTextInput(),
                  _buildListChip(icons),
                  _buildConfirmButton(icons),
                ],
              ),
            ),
          );
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          borderType: BorderType.Rect,
          // radius: const Radius.circular(kDefaultBorderRadius),
          child: const Center(
            child: Icon(
              Icons.add,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(List<Icon> icons) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
      ),
      child: ElevatedButton(
        onPressed: () {
          final object = icons[_controller.chipIndex.value];
          if (_controller.formKey.currentState!.validate()) {
            final task = Task(
              title: _controller.editController.text,
              icon: object.icon!.codePoint,
              color: object.color!.toHex(),
            );
            Get.back();
            _controller.addTask(task)
                ? EasyLoadingManager.showSuccess(status: 'Save success')
                : EasyLoadingManager.showError(status: 'Save unsuccess');

            //* Clear cache
            _controller.editController.clear();
            _controller.changeChipIndex(0);
          }
        },
        style: ElevatedButton.styleFrom(
          primary: blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              kDefaultBorderRadius,
            ),
          ),
          minimumSize: const Size(double.infinity, 40),
        ),
        child: const Text('Confirm'),
      ),
    );
  }

  Widget _buildListChip(List<Icon> icons) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.wp),
      child: Wrap(
        spacing: 2.0.wp,
        children: icons.map((e) {
          return Obx(() {
            final index = icons.indexOf(e);
            return ChoiceChip(
              selectedColor: Colors.grey[300],
              pressElevation: 0,
              backgroundColor: Colors.white,
              label: e,
              selected: _controller.chipIndex.value == index,
              onSelected: (_) {
                _controller.changeChipIndex(index);
              },
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
      ),
      child: TextFormField(
        controller: _controller.editController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Title',
        ),
        maxLength: 16,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your task title';
          }
          return null;
        },
      ),
    );
  }
}
