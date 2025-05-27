import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/global/localization/supported_locales.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';

part 'states/app_manager_state.dart';

@singleton
class AppManagerCubit extends Cubit<AppManagerState> {
  AppManagerCubit() : super(AppManagerInitial());

  Future<void> emitUnauthorizedState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "");
    prefs.setBool("is_login", false);
    emit(UnauthorizedState());
  }

  void emitDeleteSuccess<T extends DeleteModel>(T item) {
    emit(DeletedState<T>(item));
  }

  void emitLanguageChanged() {
    emit(LanguageChangedState());
  }
}
