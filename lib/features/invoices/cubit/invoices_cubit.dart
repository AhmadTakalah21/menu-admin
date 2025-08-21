import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/invoices/service/invoices_service.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';

part 'states/invoices_state.dart';

part 'states/waiters_state.dart';

part 'states/general_invoices_state.dart';

part 'states/update_status_to_paid_state.dart';

part 'states/add_invoice_to_table_state.dart';

@injectable
class InvoicesCubit extends Cubit<GeneralInvoicesState> {
  InvoicesCubit(this.invoicesService) : super(GeneralInvoicesInitial());
  final InvoicesService invoicesService;

  String? date;
  int? adminId;
  int? tableId;

  int? addInvoiceTableId;

  void setDate(String? date) {
    this.date = date;
  }

  void setAdminId(AdminModel? admin) {
    adminId = admin?.id;
  }

  void setTableId(TableModel? table) {
    tableId = table?.id;
  }

  void setAddInvoiceTableId(TableModel? table) {
    addInvoiceTableId = table?.id;
  }

  void resetParams() {
    date = null;
    adminId = null;
    tableId = null;
  }

  Future<void> getInvoices(int page) async {
    emit(InvoicesLoading());
    try {
      final invoices = await invoicesService.getInvoices(
        page,
        adminId: adminId,
        date: date,
        tableId: tableId,
      );
      if (invoices.data.isEmpty) {
        emit(InvoicesEmpty("no_invoices".tr()));
      } else {
        emit(InvoicesSuccess(invoices));
      }
    } catch (e) {
      emit(InvoicesFail(e.toString()));
    }
  }

  Future<void> getWaiters() async {
    emit(WaitersLoading());
    try {
      final waiters = await invoicesService.getWaiters();
      if (waiters.isEmpty) {
        emit(WaitersEmpty("no_waiters".tr()));
      } else {
        emit(WaitersSuccess(waiters));
      }
    } catch (e) {
      emit(WaitersFail(e.toString()));
    }
  }

  Future<void> updateStatusToPaid(int invoiceId, int index) async {
    emit(UpdateStatusToPaidLoading(index));
    try {
      await invoicesService.updateStatusToPaid(invoiceId);

      emit(UpdateStatusToPaidSuccess("status_updated".tr(), index));
    } catch (e) {
      if (e is DioException) {
        emit(UpdateStatusToPaidFail(e.message ?? e.toString(), index));
      } else {
        emit(UpdateStatusToPaidFail(e.toString(), index));
      }
    }
  }

  Future<void> addInvoiceToTable() async {
    final id = addInvoiceTableId;
    if (id == null) {
      emit(AddInvoiceToTableFail("table_required".tr()));
      return;
    }
    emit(AddInvoiceToTableLoading());
    try {
      final invoice = await invoicesService.addInvoiceToTable(id);
      emit(AddInvoiceToTableSuccess(invoice,"status_updated".tr()));
    } on DioException catch (e) {
      emit(AddInvoiceToTableFail(e.message ?? e.toString()));
    } catch (e) {
      emit(AddInvoiceToTableFail(e.toString()));
    }
  }


  void addInvoiceToTableFor(int tableId) {
    addInvoiceTableId = tableId;
    addInvoiceToTable();
  }

  Future<void> applyCouponToInvoice(int invoiceId, int couponId) async {
    emit(ApplyCouponLoading());
    try {
      final updated = await invoicesService.addCouponToInvoice(
        invoiceId: invoiceId,
        couponId: couponId,
      );
      emit(ApplyCouponSuccess(updated));
    } catch (e) {
      emit(ApplyCouponFail(e.toString()));
    }
  }

  Future<DrvierInvoiceModel> applyCouponOnce({
    required int invoiceId,
    required int couponId,
    int? tableId,

  }) {
    return invoicesService.addCouponToInvoice(
      invoiceId: invoiceId,
      couponId: couponId,
      tableId: tableId,

    );
  }






}
