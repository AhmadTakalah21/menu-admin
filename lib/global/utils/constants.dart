import 'package:flutter/material.dart';

abstract class AppConstants {
  static const restaurantId = "2";
  static const languages = ["EN", "AR"];
  static const String restaurantLogo = 'restaurantLogo';
  static const String restaurantBackgroundColor = 'restaurantBackgroundColor';

  static const String googleMapsApiKey = 'AIzaSyBhtWIKwjA8gN0NRSPakROXE_zpMHo_AJQ';


  static const duration1m = Duration(minutes: 1);
  static const duration20s = Duration(seconds: 20);
  static const duration15s = Duration(seconds: 15);
  static const duration10s = Duration(seconds: 10);
  static const duration2s = Duration(seconds: 2);

  static const borderRadiusCircle = BorderRadius.all(Radius.circular(100));
  static const borderRadius50 = BorderRadius.all(Radius.circular(50));
  static const borderRadius30 = BorderRadius.all(Radius.circular(30));
  static const borderRadius25 = BorderRadius.all(Radius.circular(25));
  static const borderRadius20 = BorderRadius.all(Radius.circular(20));
  static const borderRadius15 = BorderRadius.all(Radius.circular(15));
  static const borderRadius10 = BorderRadius.all(Radius.circular(10));
  static const borderRadius5 = BorderRadius.all(Radius.circular(5));
  static const borderRadiusT25 = BorderRadius.vertical(
    top: Radius.circular(25),
  );
  static const borderRadiusL10 = BorderRadius.only(
    topLeft: Radius.circular(10),
    bottomLeft: Radius.circular(10),
  );
  static const borderRadiusR10 = BorderRadius.only(
    topRight: Radius.circular(10),
    bottomRight: Radius.circular(10),
  );
  static const borderRadiusBlTr20 = BorderRadius.only(
    bottomLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );
  static const borderRadiusTlBr20 = BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );
  static const paddingB10 = EdgeInsets.only(bottom: 10);

  static const paddingR5 = EdgeInsets.only(right: 5);
  static const paddingV12 = EdgeInsets.symmetric(vertical: 12);
  static const paddingV10 = EdgeInsets.symmetric(vertical: 10);
  static const paddingV16 = EdgeInsets.symmetric(vertical: 16);
  static const paddingH4 = EdgeInsets.symmetric(horizontal: 4);
  static const paddingH16 = EdgeInsets.symmetric(horizontal: 16);
  static const paddingH30 = EdgeInsets.symmetric(horizontal: 30);
  static const paddingH20 = EdgeInsets.symmetric(horizontal: 20);
  static const paddingH10 = EdgeInsets.symmetric(horizontal: 10);
  static const paddingH40 = EdgeInsets.symmetric(horizontal: 40);
  static const paddingH60 = EdgeInsets.symmetric(horizontal: 60);
  static const paddingH36V12 =
  EdgeInsets.symmetric(horizontal: 36, vertical: 12);
  static const paddingH36V6 = EdgeInsets.symmetric(horizontal: 36, vertical: 6);
  static const paddingH12V4 = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 4,
  );
  static const paddingH4V10 = EdgeInsets.symmetric(horizontal: 4, vertical: 10);
  static const paddingH16V8 = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const paddingH8V4 = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const paddingV8 = EdgeInsets.symmetric(vertical: 8);
  static const paddingH8 = EdgeInsets.symmetric(horizontal: 8);
  static const padding30 = EdgeInsets.all(30);
  static const padding20 = EdgeInsets.all(20);
  static const padding18 = EdgeInsets.all(18);
  static const padding16 = EdgeInsets.all(16);
  static const padding14 = EdgeInsets.all(14);
  static const padding12 = EdgeInsets.all(12);
  static const padding10 = EdgeInsets.all(10);
  static const padding8 = EdgeInsets.all(8);
  static const padding4 = EdgeInsets.all(4);
  static const padding6 = EdgeInsets.all(6);
  static const padding2 = EdgeInsets.all(2);
  static const padding0 = EdgeInsets.zero;
}
