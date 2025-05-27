import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/sales/service/sales_service.dart';
import 'package:user_admin/features/tables/model/order_details_model/order_details_model.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'states/sales_state.dart';

part 'states/general_sales_state.dart';

@injectable
class SalesCubit extends Cubit<GeneralSalesState> {
  SalesCubit(this.salesService) : super(GeneralSalesInitial());
  final SalesService salesService;

  String? search;
  String? startDate;
  String? endDate;

  void setStartDate(String? startDate) {
    this.startDate = startDate;
  }

  void setEndDate(String? endDate) {
    this.endDate = endDate;
  }

  void setSearch(String? search) {
    this.search = search;
  }

  void resetParams() {
    search = null;
    startDate = null;
    endDate = null;
  }

  Future<void> getSales(int page) async {
    emit(SalesLoading());
    try {
      final response = await salesService.getSales(
        page,
        search: search,
        startDate: startDate,
        endDate: endDate,
      );
      if (response.data.isEmpty) {
        emit(SalesEmpty("no_sales".tr()));
      } else {
        emit(SalesSuccess(response));
      }
    } catch (e) {
      if (e is DioException) {
        emit(SalesFail(e.message ?? e.toString()));
      } else {
        emit(SalesFail(e.toString()));
      }
    }
  }
}
