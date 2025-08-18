part of 'restaurant_service.dart';

@Injectable(as: RestaurantService)
class RestaurantServiceImp implements RestaurantService {
  final dio = DioClient();

  @override
  Future<RestaurantModel> getRestaurantInfo() async {
    try {
      final response = await dio.get(
        "/customer_api/show_restaurant_by_name_or_id?id=${AppConstants.restaurantId}",
      );

      final data = response.data["data"] as Map<String, dynamic>;
      return RestaurantModel.fromJson(data);
    } catch (e,stacktrace) {
      if(kDebugMode) print("stacktrace $stacktrace");
      rethrow;
    }
  }
}
