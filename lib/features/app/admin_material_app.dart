import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/view/sign_in_view.dart';
import 'package:user_admin/global/widgets/restart_app_widget.dart';

class AdminMaterialApp extends StatefulWidget {
  const AdminMaterialApp({super.key, required this.initialView});

  final Widget initialView;

  @override
  State<AdminMaterialApp> createState() => _AdminMaterialAppState();
}

class _AdminMaterialAppState extends State<AdminMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is UnauthorizedState) {
          Get.to(() => const SignInView());
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
              home: widget.initialView,
            ),
          );
        },
      ),
    );
  }
}
