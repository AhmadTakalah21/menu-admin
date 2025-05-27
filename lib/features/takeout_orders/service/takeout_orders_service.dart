import 'package:injectable/injectable.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part "takeout_orders_service_imp.dart";

abstract class TakeoutOrdersService {
  Future<PaginatedModel<DrvierInvoiceModel>> getTakeoutOrders(int page);

  Future<void> changeDriverOfOrder(int deliveryId, int invoiceId);

  Future<void> updateStatusToRecieved(int invoiceId);

  Future<void> updateTakeoutOrderStatus(int invoiceId, String status);
}
