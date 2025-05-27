part of 'drivers_service.dart';

@Injectable(as: DriversService)
class DriversServiceImp implements DriversService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<DriverModel>> getDrivers({
    required bool isActive,
    int? page,
  }) async {
    final pageParam = page != null ? "page=$page" : "";
    const perPageParam = "per_page=10";
    final url = isActive ? "show_deliveries_active" : "show_deliveries";
    try {
      final response =
          await dio.get("/admin_api/$url?$perPageParam&$pageParam");

      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => DriverModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addDriver(
    AddDriverModel addDriverModel, {
    required bool isEdit,
    XFile? image,
  }) async {
    final url = isEdit ? "update" : "add";
    try {
      final map = addDriverModel.toJson();
      if (image != null) {
        map['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        );
      }
      await dio.post(
        "/admin_api/${url}_delivery",
        data: FormData.fromMap(map),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedModel<DrvierInvoiceModel>> getDriverInvoices(
    int driverId, {
    int? page,
  }) async {
    final pageParam = page != null ? "page=$page" : "";
    const perPageParam = "per_page=10";
    try {
      final response = await dio.get(
        "/admin_api/show_orders_delivery?id=$driverId&$perPageParam&$pageParam",
      );
      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => DrvierInvoiceModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
