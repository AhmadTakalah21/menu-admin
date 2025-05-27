part of "profile_service.dart";

@Injectable(as: ProfileService)
class ProfileServiceImp implements ProfileService {
  final dio = DioClient();

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get("/admin_api/show_admin");
      final profileJson = response.data["data"];

      return ProfileModel.fromJson(profileJson);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(UpdateProfileModel updateProfileModel) async {
    try {
      await dio.post(
        "/admin_api/update_admin",
        data: FormData.fromMap(
          updateProfileModel.toJson(),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
