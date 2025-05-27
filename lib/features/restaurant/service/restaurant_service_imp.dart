part of 'restaurant_service.dart';

@Injectable(as: RestaurantService)
class RestaurantServiceImp implements RestaurantService {
  final dio = DioClient();

  @override
  Future<RestaurantModel> getRestaurant() async {
    try {
      final response = await dio.get("/admin_api/show_admin");
      final restaurantJson =
          response.data["data"]["restaurant"] as Map<String, dynamic>;

      return RestaurantModel.fromJson(restaurantJson);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateRestaurant(
    UpdateRestaurantModel updateRestaurantModel, {
    XFile? logo,
    XFile? cover,
  }) async {
    try {
      final map = updateRestaurantModel.toJson();
      if (logo != null) {
        map['logo'] = await MultipartFile.fromFile(
          logo.path,
          filename: logo.name,
        );
      }
      if (cover != null) {
        map['cover'] = await MultipartFile.fromFile(
          cover.path,
          filename: cover.name,
        );
      }
      await dio.post(
        "/admin_api/update_restaurant_admin",
        data: FormData.fromMap(map),
      );
      
    } catch (e) {
      rethrow;
    }
  }
}
