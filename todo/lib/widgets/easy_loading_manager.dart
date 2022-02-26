import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EasyLoadingManager {
  static void showLoading({String status = ''}) {
    if (EasyLoading.isShow) return;

    EasyLoading.show(
      indicator: Theme(
        data: ThemeData(
          cupertinoOverrideTheme: const CupertinoThemeData(
            brightness: Brightness.dark,
          ),
        ),
        child: const CupertinoActivityIndicator(),
      ),
      status: status,
      maskType: EasyLoadingMaskType.black,
    );
  }

  static void showSuccess({String status = ''}) {
    EasyLoading.showSuccess(status);
  }

  static void showError({String status = ''}) {
    EasyLoading.showError(status);
  }

  static void showInfo({String status = ''}) {
    EasyLoading.showInfo(
      status,
      duration: const Duration(milliseconds: 1000),
    );
  }

  static void close() {
    EasyLoading.dismiss(animation: false);
  }
}
