part of "invoices_service.dart";

@Injectable(as: InvoicesService)
class InvoicesServiceImp implements InvoicesService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<DrvierInvoiceModel>> getInvoices(
    int page, {
    String? date,
    int? tableId,
    int? adminId,
  }) async {
    try {
      const perPageParam = "per_page=10";
      final pageParam = "page=$page";
      final tableIdParam = tableId != null ? "table_id=$tableId" : "";
      final adminIdParam = adminId != null ? "admin_id=$adminId" : "";
      final dateParam = date != null ? "date=$date" : "";
      final response = await dio.get(
        "/admin_api/show_invoices?$pageParam&$perPageParam&$tableIdParam&$adminIdParam&$dateParam",
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

  @override
  Future<void> updateStatusToPaid(int invoiceId) async {
    try {
      await dio.patch("/admin_api/update_status_invoice_paid?id=$invoiceId");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdminModel>> getWaiters() async {
    try {
      final response = await dio.get("/admin_api/show_waiters");
      final waitersJson = response.data["data"] as List;

      return List.generate(
        waitersJson.length,
        (index) => AdminModel.fromJson(
          waitersJson[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addInvoiceToTable(int tableId) async {
    try {
      await dio.post("/admin_api/add_invoice_to_table?table_id=$tableId");
    } catch (e) {
      rethrow;
    }
  }
}
