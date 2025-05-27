import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/items/model/add_order_item/add_order_item.dart';
import 'package:user_admin/features/tables/model/add_service_to_order_model/add_service_to_order_model.dart';
import 'package:user_admin/features/tables/model/edit_table_model/edit_table_model.dart';
import 'package:user_admin/features/tables/model/order_details_model/order_details_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';

part 'tables_service_imp.dart';

abstract class TablesService {
  Future<TableModel> editTable(
    EditTableModel editTableModel, {
    required bool isEdit,
  });

  Future<PaginatedModel<OrderDetailsModel>> getOrders({
    int? tableId,
    int? invoiceId,
    int? page,
  });

  Future<void> acceptAllOrders(int tableId, {String? status});

  Future<void> editOrder(AddOrderItem addOrderItem, {int? itemId});

  Future<void> addOrder(Map<String, dynamic> map);

  Future<void> addService(AddServiceToOrderModel addService);
}
