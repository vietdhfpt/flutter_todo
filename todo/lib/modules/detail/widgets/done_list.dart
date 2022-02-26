import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/utils/text_styles.dart';
import '../../../core/values/colors.dart';
import '../../../core/values/constants.dart';
import '../../home/controller.dart';

class DoneList extends StatelessWidget {
  final _controller = Get.find<HomeController>();
  DoneList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.doneTodos.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 2,
              ),
              child: Text(
                'Completed(${_controller.doneTodosLength})',
                style: buttonStyle.copyWith(color: Colors.grey),
              ),
            ),
            ..._controller.doneTodos.map((element) {
              final titleElement = element['title'];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 2.8,
                  vertical: kDefaultPadding,
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(Icons.done, color: blue),
                    ),
                    const SizedBox(width: kDefaultSpacing),
                    Text(
                      titleElement,
                      style: normalStyle.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      }
    });
  }
}
