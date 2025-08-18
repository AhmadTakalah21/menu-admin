import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/app_manager/service/app_manager_service.dart';
import 'package:user_admin/features/sign_in/model/question_model/question_model.dart';
import 'package:user_admin/global/localization/supported_locales.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';

part 'states/app_manager_state.dart';
//part 'states/questions_state.dart';

@singleton
class AppManagerCubit extends Cubit<AppManagerState> {
  AppManagerCubit(this.appManagerService) : super(AppManagerInitial());
  final AppManagerService appManagerService;

  List<QuestionModel>? questions;

  // Future<void> getQuestions(Locale locale) async {
  //   final questions = this.questions;
  //   final language = locale == SupportedLocales.english ? "en" : "ar";
  //   if (questions != null) {
  //     if (questions.isEmpty) {
  //       emit(QuestionsEmpty("No Questions"));
  //     } else {
  //       emit(QuestionsSuccess(questions));
  //     }
  //     return;
  //   } else {
  //     emit(QuestionsLoading());
  //     try {
  //       final questions = await appManagerService.getQuestions(language);
  //       this.questions = questions;
  //       if (questions.isEmpty) {
  //         emit(QuestionsEmpty("No Questions"));
  //       } else {
  //         emit(QuestionsSuccess(questions));
  //       }
  //     } catch (e) {
  //       emit(QuestionsFail(e.toString()));
  //     }
  //   }
  // }

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
