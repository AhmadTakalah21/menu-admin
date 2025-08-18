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
      if(kDebugMode) print(stacktrace);
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

  @override
  Future<void> resetPassword(ResetPasswordModel resetPasswordModel) async {
    try {
      await dio.post(
        "/admin_api/reset_password",
        data: FormData.fromMap(resetPasswordModel.toJson()),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetViaEmail(ForgetPassEmailModel forgetPassEmailModel) async {
    try {
      const duration = AppConstants.duration1m;
      final data = FormData.fromMap(forgetPassEmailModel.toJson());
      await dio.post(
        "/admin_api/forget_password",
        data: data,
        duration: duration,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetViaQuestion(ForgetPassQuestModel model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final post = FormData.fromMap(model.toJson());

      final response = await dio.post("/admin_api/forget_password", data: post);

      final token = response.data["data"]["token"];
      prefs.setString("token", token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyCode(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await dio.post("/admin_api/check_code?$code");

      final token = response.data["data"]["token"];
      prefs.setString("token", token);
    } catch (e) {
      
      rethrow;
    }
  }

  @override
  Future<void> changePassword(ChangePasswordModel changePasswordModel) async {
    try {
      final post = FormData.fromMap(changePasswordModel.toJson());
      await dio.post("/admin_api/change_password", data: post);
    } catch (e) {
      rethrow;
    }
  }

}
