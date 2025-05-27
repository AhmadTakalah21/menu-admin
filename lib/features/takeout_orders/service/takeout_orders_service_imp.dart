part of "takeout_orders_service.dart";

@Injectable(as: TakeoutOrdersService)
class TakeoutOrdersServiceImp implements TakeoutOrdersService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<DrvierInvoiceModel>> getTakeoutOrders(int page) async {
    const perPageParam = "per_page=10";
    try {
      final response = await dio.get(
        "/admin_api/show_orders_takeout?page=$page&$perPageParam",
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
  Future<void> changeDriverOfOrder(int deliveryId, int invoiceId) async {
    final invoiceIdParam = "invoice_id=$invoiceId";
    final deliveryIdParam = "delivery_id=$deliveryId";
    try {
      await dio.post(
        "/admin_api/give_order_to_delivery?$deliveryIdParam&$invoiceIdParam",
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateStatusToRecieved(int invoiceId) async {
    try {
      await dio.patch(
        "/admin_api/update_status_invoice_received?id=$invoiceId",
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTakeoutOrderStatus(int invoiceId, String status) async {
    try {
      await dio.post(
        "/admin_api/update_takeout",
        data: {
          'id': invoiceId,
          'status': status,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
