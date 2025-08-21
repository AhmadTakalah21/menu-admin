import 'package:bloc/bloc.dart';
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

  // فلاتر الـAPI الموجودة مسبقًا
  String? search;
  String? startDate;
  String? endDate;

  // كاش محلي لآخر نتيجة حتى نبحث محليًا بدون API
  PaginatedModel<OrderDetailsModel>? _salesCache;

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

      // نخزّن النتيجة لعمليات البحث المحلي
      _salesCache = response;

      if (response.data.isEmpty) {
        emit(SalesEmpty("no_sales".tr()));
      } else {
        emit(SalesSuccess(response));
      }
    } catch (e) {
      emit(SalesFail(e.toString()));
    }
  }

  /// بحث محلي بالاسم داخل النتيجة الحالية بدون استدعاء API
  /// يعتمد على الحقل `name` في OrderDetailsModel.
  void searchByName(String query) {
    final q = query.trim().toLowerCase();
    if (_salesCache == null) return;

    if (q.isEmpty) {
      // رجّع القائمة الأصلية من الكاش
      emit(SalesSuccess(_salesCache!));
      return;
    }

    final filtered = _salesCache!.data.where((o) {
      final name = (o.name ?? '').toLowerCase();
      return name.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      emit(SalesEmpty("no_sales".tr()));
    } else {
      // نحافظ على نفس الـmeta ونبدّل الـdata فقط
      final paged = PaginatedModel<OrderDetailsModel>(
        data: filtered,
        meta: _salesCache!.meta,
      );
      emit(SalesSuccess(paged));
    }
  }

  /// إلغاء البحث المحلي وإظهار البيانات الأصلية
  void clearSearch() {
    if (_salesCache != null) {
      emit(SalesSuccess(_salesCache!));
    }
  }
}
