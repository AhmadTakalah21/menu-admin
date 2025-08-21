import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/drivers/model/driver_model/driver_model.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/takeout_orders/service/takeout_orders_service.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'states/takeout_orders_state.dart';
part 'states/change_driver_of_order_state.dart';
part 'states/update_status_to_received_state.dart';
part 'states/update_takeout_order_status_state.dart';
part 'states/general_takeout_orders_state.dart';

@injectable
class TakeoutOrdersCubit extends Cubit<GeneralTakeoutOrdersState> {
  TakeoutOrdersCubit(this.takeoutOrdersService)
      : super(GeneralTakeoutOrdersInitial());

  final TakeoutOrdersService takeoutOrdersService;

  int? deliveryId;

  /// كاش آخر نتيجة لتمكين البحث المحلي بدون ضرب API
  PaginatedModel<DrvierInvoiceModel>? _ordersCache;

  void setDeliveryId(DriverModel? driver) {
    deliveryId = driver?.id;
  }

  Future<void> getTakeoutOrders(int page) async {
    emit(TakeoutOrdersLoading());
    try {
      final response = await takeoutOrdersService.getTakeoutOrders(page);

      // خزّن النتيجة للبحث المحلي
      _ordersCache = response;

      if (response.data.isEmpty) {
        emit(TakeoutOrdersEmpty("no_orders".tr()));
      } else {
        emit(TakeoutOrdersSuccess(response));
      }
    } catch (e) {
      emit(TakeoutOrdersFail(e.toString()));
    }
  }

  Future<void> changeDriverOfOrder(int invoiceId) async {
    final deliveryId = this.deliveryId;
    if (deliveryId == null) {
      emit(ChangeDriverOfOrderFail("driver_empty".tr()));
      return;
    }
    emit(ChangeDriverOfOrderLoading());
    try {
      await takeoutOrdersService.changeDriverOfOrder(deliveryId, invoiceId);
      emit(ChangeDriverOfOrderSuccess("driver_changed".tr()));
      this.deliveryId = null;
    } catch (e) {
      emit(ChangeDriverOfOrderFail(e.toString()));
    }
  }

  Future<void> updateStatusToRecieved(int invoiceId, int index) async {
    emit(UpdateStatusToReceivedLoading(index));
    try {
      await takeoutOrdersService.updateStatusToRecieved(invoiceId);
      emit(UpdateStatusToReceivedSuccess("status_updated".tr(), index));
    } catch (e) {
      emit(UpdateStatusToReceivedFail(e.toString(), index));
    }
  }

  Future<void> updateTakeoutOrderStatus(int invoiceId, String status) async {
    emit(UpdateTakeoutOrderStatusLoading());
    try {
      await takeoutOrdersService.updateTakeoutOrderStatus(invoiceId, status);
      emit(UpdateTakeoutOrderStatusSuccess("status_updated".tr()));
    } catch (e) {
      emit(UpdateTakeoutOrderStatusFail(e.toString()));
    }
  }

  // ---------------------------
  // البحث المحلي بالاسم/الهاتف/المنطقة/الرقم
  // ---------------------------

  /// يبحث محليًا في الكاش الحالي عن طريق الاسم (وحقول إضافية مفيدة).
  /// لا يستدعي API ولا يضيف حقول جديدة، فقط يفلتر البيانات الموجودة.
  void searchByName(String query) {
    final q = query.trim().toLowerCase();
    if (_ordersCache == null) return;

    if (q.isEmpty) {
      // رجّع الأصل
      emit(TakeoutOrdersSuccess(_ordersCache!));
      return;
    }

    final filtered = _ordersCache!.data.where((inv) {
      final user = (inv.user ?? '').toLowerCase();
      final username = (inv.username ?? '').toLowerCase();
      final userPhone = (inv.userPhone ?? '').toLowerCase();
      final deliveryName = (inv.deliveryName ?? '').toLowerCase();
      final deliveryPhone = (inv.deliveryPhone ?? '').toLowerCase();
      final region = (inv.region ?? '').toLowerCase();
      final idStr = (inv.id?.toString() ?? '');
      final priceStr = (inv.price?.toString() ?? '');

      return user.contains(q) ||
          username.contains(q) ||
          userPhone.contains(q) ||
          deliveryName.contains(q) ||
          deliveryPhone.contains(q) ||
          region.contains(q) ||
          idStr.contains(q) ||
          priceStr.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      emit(TakeoutOrdersEmpty("no_orders".tr()));
    } else {
      final paged = PaginatedModel<DrvierInvoiceModel>(
        data: filtered,
        meta: _ordersCache!.meta,
      );
      emit(TakeoutOrdersSuccess(paged));
    }
  }

  /// يلغي الفلترة ويعيد إظهار البيانات الأصلية من الكاش.
  void clearSearch() {
    if (_ordersCache != null) {
      emit(TakeoutOrdersSuccess(_ordersCache!));
    }
  }
}
