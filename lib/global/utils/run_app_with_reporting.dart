import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app/admin_app.dart';
import 'package:user_admin/firebase_options.dart';
import 'package:user_admin/global/blocs/user_admin_bloc_observer.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/services/notafications_service/notafications_service.dart';
import 'package:user_admin/global/utils/utils.dart';

Future<void> runAppWithReporting() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      await configureDependencies();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final subscription = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> results) async {
        if (results.isNotEmpty && !results.contains(ConnectivityResult.none)) {
          await get<NotaficationsService>().initialize();
          if (kDebugMode) {
            print("Internet is back 🟢");
          }
        } else {
          if (kDebugMode) {
            print("Lost internet 🔴");
          }
        }
      });



      final initialView = await Utils.determineInitialRoute();
      final app = AdminApp(initialView: initialView);

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      Bloc.observer = AdminAppBlocObserver();
      runApp(app);
      subscription.cancel();
    },
    (error, stackTrace) {
      debugPrint('runAppWithReporting error: $error');
      debugPrint('runAppWithReporting stackTrace: $stackTrace');
    },
  );
}
