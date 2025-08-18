import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/sign_in/view/sign_in_view.dart';
import 'package:user_admin/features/welcome/view/welcome_view.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';

abstract class Utils {
  static Color? stringToColor(String color) {
    final hex = int.tryParse(color.substring(6, 16));
    if (hex == null) return null;
    return Color(hex);
  }

  static Widget determineInitialRoute(RestaurantModel restaurant) {
    final prefs = get<SharedPreferences>();
    final isLogin = prefs.getBool("is_login") ?? false;

    if (isLogin) {
      final adminString = prefs.getString("admin_data")!;
      final admin = SignInModel.fromString(adminString);

      return WelcomeView(admin: admin,restaurant:restaurant);
    } else {
      return SignInView(restaurant: restaurant);
    }

    // final signInModelString = prefs.getString("admin_data");
    // SignInModel? signInModel;
    // if (signInModelString == null) {
    //   // TODO check this
    //   //return const SignInView();
    //   return const SplashView();
    // } else {
    //   signInModel = SignInModel.fromString(signInModelString);
    // }
    // if (isLogin) {
    //   return WelcomeView(signInModel: signInModel);
    // } else {
    //   return SignInView(restaurant: signInModel.restaurant);
    // }
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

  static bool hasPermission(
      List<RoleModel> permissions, String permissionName) {
    return permissions.any((permission) => permission.name == permissionName);
  }
}
