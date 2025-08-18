part of 'app_manager_service.dart';

@Injectable(as: AppManagerService)
class AppManagerServiceImp implements AppManagerService {
  final dio = DioClient();

  @override
  Future<List<QuestionModel>> getQuestions(String language) async {
    try {
      final response = await dio.get(
        "/user_api/questions",
        headers: {"language": language},
      );

      final data = response.data["data"] as List;
      return List.generate(
        data.length,
        (index) => QuestionModel.fromJson(data[index] as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }
}
