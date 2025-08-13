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
        data: FormData.fromMap(signInPostModel.toJson()),
      );

      final data = response.data["data"] as Map<String, dynamic>;
      final token = data["token"];
      final restaurantId = data["restaurant_id"];

      await prefs.setString("token", token);
      if (restaurantId != null) {
        await prefs.setInt("restaurant_id", restaurantId);
      }

      return SignInModel.fromJson(data);
    } catch (e, stacktrace) {
      print(stacktrace);
      rethrow;
    }
  }


  @override
  Future<void> signOut() async {
    try {
      await dio.get("/api/logout");

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("token");
      await prefs.remove("restaurant_id");
    } catch (e) {
      rethrow;
    }
  }

}
