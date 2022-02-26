import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/text_styles.dart';
import '../../../core/values/constants.dart';
import '../../home/controller.dart';

class DoingList extends StatelessWidget {
  final _controller = Get.find<HomeController>();
  DoingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.doingTodos.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            ..._controller.doingTodos.map((element) {
              final titleElement = element['title'];
              final doneElement = element['done'];

              return _buildItem(doneElement, titleElement);
            }).toList(),
            _buildSeperator(),
          ],
        );
      }
    });
  }

  Widget _buildItem(doneElement, titleElement) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 2.8,
        vertical: kDefaultPadding,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              fillColor: MaterialStateProperty.resolveWith(
                (states) => Colors.grey,
              ),
              value: doneElement,
              onChanged: (value) {
                _controller.doneTodo(titleElement);
              },
            ),
          ),
          const SizedBox(width: kDefaultSpacing),
          Text(
            titleElement,
            style: normalStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSeperator() {
    return const Divider(
      thickness: 1.8,
      indent: kDefaultPadding * 2,
      endIndent: kDefaultPadding * 2,
    );
  }
}
