part of "home_service.dart";

@Injectable(as: HomeService)
class HomeServiceImp implements HomeService {
  final dio = DioClient();

  @override
  Future<List<CategoryModel>> getCategories({int? categoryId}) async {
    try {
      final categoryIdParam =
          categoryId != null ? "?category_id=$categoryId" : "";

      final response = await dio.get(
        "/admin_api/show_admin_categories$categoryIdParam",
      );
      final data = response.data["data"] as List;

      return List.generate(
        data.length,
        (index) => CategoryModel.fromJson(
          data[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesSub() async {
    try {
      final response = await dio.get(
        "/admin_api/show_categories_sub",
      );
      final data = response.data["data"] as List;

      return List.generate(
        data.length,
        (index) => CategoryModel.fromJson(
          data[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<CategoryModel> editCategory(
      EditCategoryModel editCategoryModel,
      XFile? image, {
        required bool isEdit,
      }) async {
    try {
      final url = isEdit ? "update" : "add";
      Map<String, dynamic> map = editCategoryModel.toJson();
      print("📦 editCategoryModel data: $map");

      if (image != null) {
        map['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        );
      }

      final response = await dio.post(
        "/admin_api/${url}_category",
        data: FormData.fromMap(map),
      );

      final categoryJson = response.data["data"] as Map<String, dynamic>;
      return CategoryModel.fromJson(categoryJson);
    } on DioException catch (e) {
      // طباعة مفصلة للخطأ في حالة DioException
      print("❌ DioException in editCategory:");
      print("🔹 URL: ${e.requestOptions.uri}");
      print("🔹 Method: ${e.requestOptions.method}");
      print("🔹 Status Code: ${e.response?.statusCode}");
      print("🔹 Response Data: ${e.response?.data}");
      print("🔹 Message: ${e.message}");
      throw Exception("فشل تعديل التصنيف: ${e.response?.data}");
    } catch (e) {
      // طباعة أي خطأ آخر غير معروف
      print("❌ Unknown exception in editCategory: $e");
      rethrow;
    }
  }

}
