import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/view/sign_in_view.dart';
import 'package:user_admin/features/splash/view/splash_view.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/widgets/restart_app_widget.dart';

class AdminMaterialApp extends StatefulWidget {
  const AdminMaterialApp({super.key});

  @override
  State<AdminMaterialApp> createState() => _AdminMaterialAppState();
}

class _AdminMaterialAppState extends State<AdminMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is UnauthorizedState) {
          final prefs = get<SharedPreferences>();
          final restaurantString = prefs.getString("admin_data")!;
          final restaurant = RestaurantModel.fromString(restaurantString);
          // TODO check this
          Get.to(() => SignInView(restaurant: restaurant));
        }
      },
      child: BlocBuilder<AppManagerCubit, AppManagerState>(
        builder: (context, state) {
          return RestartAppWidget(
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(fontFamily: "Alkatra"),
              home: const SplashView(),
            ),
          );
        },
      ),
    );
  }
}
