part of 'employees_details_service.dart';

@Injectable(as: EmployeesDetailsService)
class EmployeesDetailsServiceImp implements EmployeesDetailsService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<OrderRequestModel>> getEmployees(
    int page, {
    String? date,
    String? search,
    String? type,
    int? tableId,
    int? employeeId,
  }) async {
    try {
      const perPageParam = "per_page=10";
      final pageParam = "page=$page";
      final searchParam = search != null ? "search=$search" : "";
      final tableIdParam = tableId != null ? "table_id=$tableId" : "";
      final employeeIdParam = employeeId != null ? "emp_id=$employeeId" : "";
      final typeParam = type != null ? "type=$type" : "";
      final dateParam = date != null ? "date=$date" : "";
      final response = await dio.get(
        "/admin_api/show_orders_request?$perPageParam&$searchParam&$tableIdParam&$typeParam&$employeeIdParam&$dateParam&$pageParam",
      );
      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => OrderRequestModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
