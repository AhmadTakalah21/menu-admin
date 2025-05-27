import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/sign_in/view/sign_in_view.dart';
import 'package:user_admin/features/welcome/view/welcome_view.dart';

abstract class Utils {
  static Color? stringToColor(String color) {
    final hex = int.tryParse(color.substring(6, 16));
    if (hex == null) return null;
    return Color(hex);
  }

  static Future<Widget> determineInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool("is_login") ?? false;
    final signInModelString = prefs.getString("admin_data");
    if (signInModelString == null) {
      print("is fals");
      return const SignInView();

    }
    if (isLogin) {
      final signInModel = SignInModel.fromString(signInModelString);

      return WelcomeView(signInModel: signInModel);
    } else {
      print("is fals after");
      return const SignInView();
    }
  }

  static String convertDateFormat(String inputDate) {
    DateTime parsedDate = DateTime.parse(inputDate);
    String formattedDate =
        "${parsedDate.year}/${twoDigits(parsedDate.month)}/${twoDigits(parsedDate.day)}";
    return formattedDate;
  }

  static String twoDigits(int n) => n.toString().padLeft(2, '0');

  static String convertToIsoFormat(String inputDate) {
    DateFormat inputFormat = DateFormat('MM/dd/yyyy');
    DateTime parsedDate = inputFormat.parse(inputDate);

    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    return outputFormat.format(parsedDate);
  }

  static String capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
