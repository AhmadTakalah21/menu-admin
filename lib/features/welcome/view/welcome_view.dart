import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/global/localization/supported_locales.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/restart_app_widget.dart';

abstract class WelcomeViewcCallbacks {
  void changeLanguage(LanguageModel language);
}

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key, required this.admin, required this.restaurant});

  final SignInModel admin;
  final RestaurantModel restaurant;

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    implements WelcomeViewcCallbacks {
  late final AppManagerCubit appManagerCubit = context.read();
  @override
  void changeLanguage(LanguageModel language) {
    setState(() {
      if (language.locale == SupportedLocales.english) {
        context.setLocale(SupportedLocales.english);
      } else {
        context.setLocale(SupportedLocales.arabic);
      }
    });
    RestartAppWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(restaurant: widget.restaurant),
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(
      //     color: AppColors.white,
      //   ),
      //   backgroundColor: AppColors.mainColor,
      //   actions: [
      //     PopupMenuButton(
      //       offset: const Offset(0, 50),
      //       constraints: const BoxConstraints(
      //         maxWidth: 60,
      //       ),
      //       shape: ContinuousRectangleBorder(
      //         borderRadius: BorderRadius.circular(20),
      //       ),
      //       color: widget.restaurant.color,
      //       itemBuilder: (context) {
      //         return SupportedLocales.languages.map(
      //           (language) {
      //             return PopupMenuItem(
      //               onTap: () => changeLanguage(language),
      //               child: Center(
      //                 child: Container(
      //                   padding: const EdgeInsets.all(8),
      //                   decoration: BoxDecoration(
      //                     color: AppColors.white.withOpacity(0.9),
      //                     borderRadius: BorderRadius.circular(5),
      //                   ),
      //                   child: Text(
      //                     language.code,
      //                     style: const TextStyle(
      //                       color: AppColors.black,
      //                     ),
      //                     textScaler: const TextScaler.linear(0.8),
      //                   ),
      //                 ),
      //               ),
      //             );
      //           },
      //         ).toList();
      //       },
      //       child: const Icon(
      //         size: 30,
      //         Icons.language,
      //         color: AppColors.white,
      //       ),
      //     ),
      //     const SizedBox(width: 10),
      //   ],
      // ),
      drawer: MainDrawer(
        permissions: widget.admin.permissions,
        restaurant: widget.restaurant,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppConstants.padding16,
          child: Column(
            children: [
              const SizedBox(height: 100),
              SvgPicture.asset(
                "assets/images/settings.svg",
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      "welcome".tr(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Icon(Icons.build),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
