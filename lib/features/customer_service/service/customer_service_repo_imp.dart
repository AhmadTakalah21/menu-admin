part of 'customer_service_repo.dart';

@Injectable(as: CustomerServiceRepo)
class CustomerServiceRepoImp implements CustomerServiceRepo {
  final dio = DioClient();

  @override
  Future<PaginatedModel<ServiceModel>> getServices({int? page}) async {
    final pageParam = page != null ? "page=$page" : "";
    const perPageParam = "per_page=10";
    try {
      final response =
          await dio.get("/admin_api/show_services?$perPageParam&$pageParam");

      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => ServiceModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addService(
    AddServiceModel addServiceModel, {
    required bool isEdit,
  }) async {
    final url = isEdit ? "update" : "add";
    try {
      await dio.post(
        "/admin_api/${url}_service",
        data: addServiceModel.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
