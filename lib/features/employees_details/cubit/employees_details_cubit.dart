import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/employees_details/model/employee_type_enum.dart';
import 'package:user_admin/features/employees_details/model/order_request_model/order_request_model.dart';
import 'package:user_admin/features/employees_details/service/employees_details_service.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'states/employees_details_state.dart';

part 'states/general_employees_details_state.dart';

@injectable
class EmployeesDetailsCubit extends Cubit<GeneralEmployeesDetailsState> {
  EmployeesDetailsCubit(this.employeesDetailsService)
      : super(GeneralEmployeesDetailsInitial());
  final EmployeesDetailsService employeesDetailsService;

  EmployeeTypeEnum? type;
  String? date;
  String? search;
  int? employeeId;
  int? tableId;

  void resetParams() {
    date = null;
    type = null;
    search = null;
    employeeId = null;
    tableId = null;
  }

  void setDate(String? date) {
    this.date = date;
  }

  void setType(EmployeeTypeEnum? type) {
    this.type = type == EmployeeTypeEnum.all ? null : type;
  }

  void setEmployeeId(int? employeeId) {
    this.employeeId = employeeId;
  }

  void setSearch(String? search) {
    this.search = search;
  }

  void setTableId(int? tableId) {
    this.tableId = tableId;
  }

  Future<void> getEmployees(int page) async {
    emit(EmployeesDetailsLoading());
    try {
      final response = await employeesDetailsService.getEmployees(
        page,
        date: date,
        employeeId: employeeId,
        search: search,
        tableId: tableId,
        type: type?.name,
      );
      if (response.data.isEmpty) {
        emit(EmployeesDetailsEmpty("no_employees".tr()));
      } else {
        emit(EmployeesDetailsSuccess(response));
      }
    } catch (e) {
      if (e is DioException) {
        emit(EmployeesDetailsFail(e.message ?? e.toString()));
      } else {
        emit(EmployeesDetailsFail(e.toString()));
      }
    }
  }
}
