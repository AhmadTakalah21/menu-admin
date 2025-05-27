import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/customer_service/model/service_model/service_model.dart';
import 'package:user_admin/features/items/model/add_order_item/add_order_item.dart';
import 'package:user_admin/features/items/model/is_panorama_enum.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/features/tables/model/add_service_to_order_model/add_service_to_order_model.dart';
import 'package:user_admin/features/tables/model/edit_table_model/edit_table_model.dart';
import 'package:user_admin/features/tables/model/order_details_model/order_details_model.dart';
import 'package:user_admin/features/tables/model/order_status_enum.dart';
import 'package:user_admin/features/tables/service/tables_service.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../items/service/items_service.dart';

part 'states/tables_state.dart';

part 'states/general_tables_state.dart';

part 'states/edit_table_state.dart';

part 'states/table_orders_state.dart';

part 'states/accept_all_state.dart';

part 'states/edit_order_in_table_state.dart';

part 'states/add_service_to_order_state.dart';

@Injectable()
class TablesCubit extends Cubit<GeneralTablesState> {
  TablesCubit(this.tablesService) : super(GeneralTablesInitial()) {
    initWebSocket(); // يتم التنفيذ عند الإنشاء
  }
  final TablesService tablesService;
  final ItemsService itemsService = ItemsServiceImp();
  WebSocketChannel? _channel;
  bool _isConnected = false;
  List<TableModel> tablesList = [];
  BuildContext? context;

  EditTableModel editTableModel = const EditTableModel();
  AddOrderItem addOrderItem = const AddOrderItem();
  AddServiceToOrderModel addServiceToOrderModel = const AddServiceToOrderModel();


  int? itemId;
  String? count;

  void setContext(BuildContext ctx) {
    context = ctx;
  }
  void resetParams() {
    itemId = null;
    count = null;
  }

  void initWebSocket() {
    _channel?.sink.close();

    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.102:8080/app/bqfkpognxb0xxeax5bjc'),
    );

    _channel?.stream.listen(
      _handleIncomingMessage,
      onError: (error) {
        print("❌ خطأ في الاتصال: $error");
        _reconnect();
      },
      onDone: () {
        if (_isConnected) {
          print("🔌 الاتصال انقطع بشكل غير متوقع");
          _reconnect();
        }
      },
    );
  }

  void _processTableData(dynamic data) {
    try {
      print("🔵 البيانات المستلمة: $data");

      if (data['data'] != null) {
        final updatedTables = (data['data'] as List)
            .map((item) => TableModel.fromJson(item))
            .toList();

        tablesList = updatedTables; // تم تحديث هذا السطر لعدم استخدام .obs
        print("🟢 تم تحديث ${updatedTables.length} طاولة");

        // إظهار إشعار للمستخدم عند وجود تحديث
        if (updatedTables.any((table) => table.tableStatus == 1)) {
          ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(
              content: Text("تم تحديث حالة الطاولات".tr()),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print("❌ خطأ في معالجة بيانات الطاولات: $e");
    }
  }



  void _handleIncomingMessage(dynamic message) {
    print("📩 الرسالة الواردة: $message");

    try {
      final decoded = jsonDecode(message);

      if (decoded['event'] == 'pusher:connection_established') {
        _isConnected = true;
        _subscribeToChannel();
        return;
      }

      if (decoded['event'] == 'pusher:error') {
        print("⚠️ خطأ في Pusher: ${decoded['data']}");
        return;
      }

      if (decoded['event'] == 'App\\Events\\TableUpdatedEvent') {
        final rawData = decoded['data']; // هذا String
        final parsedData = jsonDecode(rawData); // ✅ فك التشفير الثاني
        _processTableData(parsedData); // ⬅️ الآن سترى البيانات بشكل صحيح
      }
    } catch (e) {
      print("❌ خطأ في تحليل الرسالة: $e");
    }
  }

  void _subscribeToChannel() {
    _channel?.sink.add(jsonEncode({
      "event": "pusher:subscribe",
      "data": {"channel": "restaurant46"}
    }));
    print("🔄 جاري الاشتراك في القناة...");
  }



  void _reconnect() {
    _isConnected = false;
    Future.delayed(Duration(seconds: 3), () {
      print("⚡ محاولة إعادة اتصال...");
      initWebSocket();
    });
  }


  @override
  Future<void> close() {
    _channel?.sink.close();
    return super.close();
  }


  Future<void> getTables({int? page}) async {
    emit(TablesLoading());
    try {
      final tables = await itemsService.getTables(page: page);
      if (tables.data.isEmpty) {
        emit(TablesEmpty("no_tables".tr()));
      } else {
        emit(TablesSuccess(tables));
      }
    } catch (e) {
      emit(TablesFail(e.toString()));
    }
  }

  void setTableId(int id) {
    editTableModel = editTableModel.copyWith(id: id);
  }

  void setIsQrTable(IsPanoramaEnum? isQr) {
    editTableModel = editTableModel.copyWith(isQrTable: isQr?.id);
  }

  void setTableNumber(String? tableNumber) {
    editTableModel = editTableModel.copyWith(
      tableNumber: tableNumber,
    );
  }

  void setItemId(ItemModel? item) {
    itemId = item?.id;
  }

  void setCount(String? count) {
    this.count = count;
    addOrderItem = addOrderItem.copyWith(count: count);
  }

  void setId(int id) {
    addOrderItem = addOrderItem.copyWith(id: id);
  }

  void setStatus(OrderStatusEnum? orderStatusEnum) {
    addOrderItem = addOrderItem.copyWith(status: orderStatusEnum?.name);
  }

  void setServiceId(ServiceModel? service) {
    addServiceToOrderModel = addServiceToOrderModel.copyWith(id: service?.id);
  }

  void setCountOfService(String count) {
    addServiceToOrderModel = addServiceToOrderModel.copyWith(count: count);
  }

  void setTableIdOfService(int tableId) {
    addServiceToOrderModel = addServiceToOrderModel.copyWith(tableId: tableId);
  }

  void setInvoiceIdOfService(int invoiceId) {
    addServiceToOrderModel =
        addServiceToOrderModel.copyWith(invoiceId: invoiceId);
  }

  Future<void> editTable({required bool isEdit, int? tableId}) async {
    if (isEdit && tableId != null) {
      setTableId(tableId);
    }

    emit(EditTableLoading());
    try {
      final editedTable = await tablesService.editTable(
        editTableModel,
        isEdit: isEdit,
      );
      final successMessage =
          isEdit ? "edit_table_success".tr() : "add_table_success".tr();
      emit(EditTableSuccess(editedTable, successMessage));
    } catch (e) {
      emit(EditTableFail(e.toString()));
    }
  }

  Future<void> getTableOrders(int tableId, {int? page}) async {
    emit(TableOrdersLoading());
    try {
      final tableOrders = await tablesService.getOrders(
        tableId: tableId,
        page: page,
      );
      if (tableOrders.data.isEmpty) {
        emit(TableOrdersEmpty("no_orders".tr()));
      } else {
        emit(TableOrdersSuccess(tableOrders));
      }
    } catch (e) {
      emit(TableOrdersFail(e.toString()));
    }
  }

  Future<void> acceptAllOrders(int tableId, {String? status}) async {
    emit(AcceptAllLoading());
    try {
      await tablesService.acceptAllOrders(tableId, status: status);
      emit(AcceptAllSuccess("status_changed".tr()));
    } catch (e) {
      if (e is DioException) {
        emit(AcceptAllFail(e.message ?? ""));
      } else {
        emit(AcceptAllFail(e.toString()));
      }
    }
  }

  Future<void> editOrder(int orderId) async {
    setId(orderId);

    emit(EditOrderInTableLoading());
    try {
      await tablesService.editOrder(addOrderItem, itemId: itemId);
      emit(EditOrderInTableSuccess("edit_order_success".tr()));
      addOrderItem = const AddOrderItem();
      resetParams();
    } catch (e) {
      emit(EditOrderInTableFail(e.toString()));
    }
  }

  Future<void> addOrder(int tableId) async {
    final count = this.count;
    if (itemId == null) {
      emit(EditOrderInTableFail("item_required".tr()));
      return;
    }
    if (count == null || count.isEmpty) {
      emit(EditOrderInTableFail("count_required".tr()));
      return;
    }
    final map = {
      "data[0][item_id]": itemId,
      "data[0][count]": count,
      "table_id": tableId
    };
    emit(EditOrderInTableLoading());
    try {
      await tablesService.addOrder(map);
      emit(EditOrderInTableSuccess("add_order_success".tr()));
      resetParams();
    } catch (e) {
      emit(EditOrderInTableFail(e.toString()));
    }
  }

  Future<void> addService() async {
    try {
      await tablesService.addService(addServiceToOrderModel);
      emit(AddServiceToOrderSuccess("add_service_success".tr()));
      addServiceToOrderModel = const AddServiceToOrderModel();
    } catch (e) {
      emit(AddServiceToOrderFail(e.toString()));
    }
  }
}
