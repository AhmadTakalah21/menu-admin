part of "tables_service.dart";

@Injectable(as: TablesService)
class TablesServiceImp implements TablesService {
  final dio = DioClient();

  @override
  Future<TableModel> editTable(
    EditTableModel editTableModel, {
    required bool isEdit,
  }) async {
    final url = isEdit ? "update" : "add";
    try {
      final response = await dio.post(
        "/admin_api/${url}_table",
        data: FormData.fromMap(editTableModel.toJson()),
      );
      final tableJson = response.data["data"] as Map<String, dynamic>;
      return TableModel.fromJson(tableJson);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedModel<OrderDetailsModel>> getOrders({
    int? tableId,
    int? invoiceId,
    int? page,
  }) async {
    String pageParam = page != null ? "page=$page" : "";
    const perPageParam = "per_page=10";
    String tableIdParam = tableId != null ? "table_id=$tableId" : "";
    try {
      final response = await dio.get(
        "/admin_api/show_orders?$tableIdParam&$pageParam&$perPageParam",
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

  @override
  Future<void> acceptAllOrders(int tableId, {String? status}) async {
    final statusParam = status != null ? "status=$status" : "";
    try {
      await dio.put("/admin_api/accept_orders?id=$tableId&$statusParam");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editOrder(AddOrderItem addOrderItem, {int? itemId}) async {
    print("🟡 itemId inside editOrder: $itemId");

    try {
      final map = {
        "id": addOrderItem.id,
        "item_id": itemId,
        "status": addOrderItem.status,
        "count": addOrderItem.count,
      };

      print("📦 Form Map: $map");

      await dio.post(
        "/admin_api/update_order",
        data: FormData.fromMap(map),
      );
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<void> addService(AddServiceToOrderModel addServiceModel) async {
    try {
      await dio.post(
        "/admin_api/add_service_to_order",
        data: FormData.fromMap(addServiceModel.toJson()),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addOrder(Map<String, dynamic> map) async {
    try {
      await dio.post(
        "/admin_api/add_order",
        data: FormData.fromMap(map),
      );
    } catch (e) {
      rethrow;
    }
  }
}
