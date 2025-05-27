import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/global/di/di.config.dart';

final get = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async => get.init();