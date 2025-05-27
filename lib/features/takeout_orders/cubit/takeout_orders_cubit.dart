import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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

  void setDeliveryId(DriverModel? driver) {
    deliveryId = driver?.id;
  }

  Future<void> getTakeoutOrders(int page) async {
    emit(TakeoutOrdersLoading());
    try {
      final response = await takeoutOrdersService.getTakeoutOrders(page);
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
      if (e is DioException) {
        emit(ChangeDriverOfOrderFail(e.message ?? e.toString()));
      } else {
        emit(ChangeDriverOfOrderFail(e.toString()));
      }
    }
  }

  Future<void> updateStatusToRecieved(int invoiceId, int index) async {
    emit(UpdateStatusToReceivedLoading(index));
    try {
      await takeoutOrdersService.updateStatusToRecieved(invoiceId);
      emit(UpdateStatusToReceivedSuccess("status_updated".tr(), index));
    } catch (e) {
      if (e is DioException) {
        emit(UpdateStatusToReceivedFail(e.message ?? e.toString(), index));
      } else {
        emit(UpdateStatusToReceivedFail(e.toString(), index));
      }
    }
  }

  Future<void> updateTakeoutOrderStatus(int invoiceId, String status) async {
    emit(UpdateTakeoutOrderStatusLoading()); // يمكن إزالة `index` من هنا
    try {
      await takeoutOrdersService.updateTakeoutOrderStatus(invoiceId, status);
      emit(UpdateTakeoutOrderStatusSuccess("status_updated".tr())); // نفس الشيء هنا
    } catch (e) {
      if (e is DioException) {
        emit(UpdateTakeoutOrderStatusFail(e.message ?? e.toString()));
      } else {
        emit(UpdateTakeoutOrderStatusFail(e.toString()));
      }
    }
  }

}