import 'package:injectable/injectable.dart';
import 'package:user_admin/features/employees_details/model/order_request_model/order_request_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'employees_details_service_imp.dart';

abstract class EmployeesDetailsService {
   Future<PaginatedModel<OrderRequestModel>> getEmployees(
    int page, {
    String? date,
    String? search,
    String? type,
    int? tableId,
    int? employeeId,
  });
}