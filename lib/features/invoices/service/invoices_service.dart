import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part "invoices_service_imp.dart";

abstract class InvoicesService {
  Future<PaginatedModel<DrvierInvoiceModel>> getInvoices(
    int page, {
    String? date,
    int? tableId,
    int? adminId,
  });

  Future<DrvierInvoiceModel> addInvoiceToTable(int tableId);

  Future<List<AdminModel>> getWaiters();

  Future<void> updateStatusToPaid(int invoiceId);

  Future<DrvierInvoiceModel> addCouponToInvoice({
    required int invoiceId,
    required int couponId,
    int? tableId,
  });
}
