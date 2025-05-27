import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';

abstract class MainSnackBar {
  static void showSuccessMessage(
      BuildContext context,
      String message, {
        Color? color,
        Duration? duration,
      }) {
    Get.snackbar(
      "نجاح",
      message,
      duration: duration ?? AppConstants.duration2s,
      backgroundColor: color ?? AppColors.green,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
      colorText: Colors.white,
      messageText: Text(
        message,
        style: TextStyle(fontSize: MediaQuery.sizeOf(context).width / 25,color:Colors.white),
      ),
    );
  }

  static void showErrorMessage(
      BuildContext context,
      String message, {
        Color? color,
        Duration? duration,
      }) {
    Get.snackbar(
      "خطأ",
      message,
      duration: duration ?? AppConstants.duration2s,
      backgroundColor: color ?? AppColors.red,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
      colorText: Colors.white,
      messageText: Text(
        message ,
        style: TextStyle(fontSize: MediaQuery.sizeOf(context).width / 25,color:Colors.white),
      ),
    );
  }
}
