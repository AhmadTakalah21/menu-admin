part of 'add_order_service.dart';

@Injectable(as: AddOrderService)
class AddOrderServiceImp implements AddOrderService {
  final dio = DioClient();

  @override
  Future<List<CategoryModel>> getCategoriesSubsItems(int restaurantId) async {
    try {
      final response = await dio.get(
        "/admin_api/show_category_subs_items",
        queries: {
          "restaurant_id": restaurantId,
        },
      );

      final categoriesJson = response.data["data"] as List;

      return List.generate(
        categoriesJson.length,
            (index) => CategoryModel.fromJson(
          categoriesJson[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addOrder(Map<String, dynamic> order) async {
    try {
      await dio.post(
        "/admin_api/add_order",
        data: FormData.fromMap(order),
      );
    } catch (e) {
      rethrow;
    }
  }
}
