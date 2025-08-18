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
    } catch (e, stackTrace) {
      print("🛑 ERROR in getInvoices: $e");
      print("📍 STACK TRACE: $stackTrace");
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
  Future<DrvierInvoiceModel> addInvoiceToTable(int tableId) async {
    try {
      final resp =
      await dio.post("/admin_api/add_invoice_to_table?table_id=$tableId");

      final raw = resp.data;
      Map<String, dynamic>? invoiceJson;

      if (raw is Map<String, dynamic>) {
        final data = raw["data"];
        if (data is Map<String, dynamic>) {
          invoiceJson = data;
        } else if (data is List && data.isNotEmpty && data.first is Map) {
          invoiceJson = data.first as Map<String, dynamic>;
        } else if (raw["invoice"] is Map<String, dynamic>) {
          invoiceJson = raw["invoice"] as Map<String, dynamic>;
        }
      }

      if (invoiceJson != null) {
        return DrvierInvoiceModel.fromJson(invoiceJson);
      }

      final page1 = await getInvoices(1, tableId: tableId);
      if (page1.data.isNotEmpty) return page1.data.first;

      throw Exception("No invoice returned from server.");
    } catch (e) {
      rethrow;
    }
  }

// InvoicesServiceImp
  @override
  Future<DrvierInvoiceModel> addCouponToInvoice({
    required int invoiceId,
    required int couponId,
    int? tableId,
  }) async {

    final res = await dio.post(
      "/admin_api/add_coupon_to_invoice",
      data: {
        "invoice_id": invoiceId,
        "coupon_id": couponId,
      },
    );

    final body = res.data as Map<String, dynamic>? ?? {};
    Map<String, dynamic>? invJson;

    final data = body['data'];
    if (data is Map<String, dynamic>) {
      if (data['invoice'] is Map<String, dynamic>) {
        invJson = data['invoice'] as Map<String, dynamic>;
      } else {
        invJson = data;
      }
    } else if (body['invoice'] is Map<String, dynamic>) {
      invJson = body['invoice'] as Map<String, dynamic>;
    }

    if (invJson != null) {
      return DrvierInvoiceModel.fromJson(invJson);
    }

    try {
      final r = await dio.get("/admin_api/show_invoice_by_id?id=$invoiceId");
      final m = r.data as Map<String, dynamic>? ?? {};
      final d = (m['data'] ?? m) as Map<String, dynamic>;
      return DrvierInvoiceModel.fromJson(d);
    } catch (_) {
    }

    if (tableId != null) {
      final page1 = await getInvoices(1, tableId: tableId);
      final match = page1.data.firstWhere(
            (e) => e.id == invoiceId,
        orElse: () => page1.data.isNotEmpty ? page1.data.first : throw Exception('No invoices'),
      );
      return match;
    }

    throw Exception("Server didn't return invoice; provide tableId to refetch");
  }


}
