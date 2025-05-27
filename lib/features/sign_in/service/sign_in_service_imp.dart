part of "sign_in_service.dart";

@Injectable(as: SignInService)
class SignInServiceImp implements SignInService {
  final dio = DioClient();

  @override
  Future<SignInModel> signIn(SignInPostModel signInPostModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final response = await dio.post(
        "/admin_api/login?model=Admin",
        data: FormData.fromMap(
          signInPostModel.toJson(),
        ),
      );
      final data = response.data["data"] as Map<String, dynamic>;
      final token = data["token"];
      prefs.setString("token", token);

      return SignInModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await dio.get("/api/logout");
    } catch (e) {
      rethrow;
    }
  }
}
