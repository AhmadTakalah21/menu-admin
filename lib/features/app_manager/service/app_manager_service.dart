import 'package:injectable/injectable.dart';
import 'package:user_admin/features/sign_in/model/question_model/question_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';

part 'app_manager_service_imp.dart';

abstract class AppManagerService {
  Future<List<QuestionModel>> getQuestions(String language);
}