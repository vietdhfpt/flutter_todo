import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/task_card.dart';

import '../../core/utils/text_styles.dart';
import '../../core/values/constants.dart';
import 'controller.dart';
import 'widgets/add_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  ...controller.tasks.map((task) => TaskCard(task: task)),
                  AddCard(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
