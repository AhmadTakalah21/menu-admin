part of 'sales_service.dart';

@Injectable(as: SalesService)
class SalesServiceImp implements SalesService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<OrderDetailsModel>> getSales(
    int page, {
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    try {
      const statusParam = "status=done";
      //const perPageParam = "per_page=10";
      final pageParam = "page=$page";
      final searchParam = search != null ? "search=$search" : "";
      final startDateParam = startDate != null ? "start_date=$startDate" : "";
      final endDateParam = endDate != null ? "end_date=$endDate" : "";
      final response = await dio.get(
        "/admin_api/show_orders?$pageParam&$statusParam&$searchParam&$startDateParam&$endDateParam",
      );
      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => OrderDetailsModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
