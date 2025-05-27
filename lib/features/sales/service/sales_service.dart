import 'package:injectable/injectable.dart';
import 'package:user_admin/features/tables/model/order_details_model/order_details_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'sales_service_imp.dart';

abstract class SalesService {
  Future<PaginatedModel<OrderDetailsModel>> getSales(
    int page, {
    String? startDate,
    String? endDate,
    String? search,
  });
}