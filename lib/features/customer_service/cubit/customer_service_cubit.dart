import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/customer_service/model/add_service_model/add_service_model.dart';
import 'package:user_admin/features/customer_service/model/service_model/service_model.dart';
import 'package:user_admin/features/customer_service/service/customer_service_repo.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'states/customer_service_state.dart';
part 'states/general_customer_service.dart';
part 'states/add_service_state.dart';

@injectable
class CustomerServiceCubit extends Cubit<GeneralCustomerService> {
  CustomerServiceCubit(this.customerServiceRepo)
      : super(GeneralCustomerServiceInitial());

  final CustomerServiceRepo customerServiceRepo;

  AddServiceModel addServiceModel = const AddServiceModel();

  String _searchQuery = '';
  Timer? _debounce;
  int _lastPage = 1;

  void searchByName(String q) {
    _searchQuery = q.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      getServices(page: _lastPage);
    });
  }

  void clearSearch() {
    if (_searchQuery.isEmpty) return;
    _searchQuery = '';
    _lastPage = 1;
    getServices(page: _lastPage);
  }
  // -----------------------------

  resetModel() {
    addServiceModel = addServiceModel.reset();
  }

  void setNameEn(String nameEn) {
    addServiceModel = addServiceModel.copyWith(nameEn: nameEn);
  }

  void setNameAr(String nameAr) {
    addServiceModel = addServiceModel.copyWith(nameAr: nameAr);
  }

  void setPrice(String price) {
    addServiceModel = addServiceModel.copyWith(price: price);
  }

  Future<void> getServices({int? page}) async {
    _lastPage = page ?? 1;

    emit(CustomerServiceLoading());
    try {
      final services = await customerServiceRepo.getServices(page: page);
      _emitWithFilter(services);
    } catch (e) {
      emit(CustomerServiceFail(e.toString()));
    }
  }

  void _emitWithFilter(PaginatedModel<ServiceModel> source) {
    if (_searchQuery.isEmpty) {
      if (source.data.isEmpty) {
        emit(CustomerServiceEmpty("no_services".tr()));
      } else {
        emit(CustomerServiceSuccess(source));
      }
      return;
    }

    final q = _searchQuery.toLowerCase();
    final filtered = source.data.where((s) {
      final n = ((s.name ?? '') +
          ' ' +
          (s.nameAr ?? '') +
          ' ' +
          (s.nameEn ?? ''))
          .toLowerCase();
      return n.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      emit(CustomerServiceEmpty("no_services".tr()));
      return;
    }

    final srcMap = json.decode(source.toString()) as Map<String, dynamic>;
    srcMap['data'] = filtered.map((e) => e.toJson()).toList();
    final rebuilt = PaginatedModel.fromString(
      json.encode(srcMap),
          (json) => ServiceModel.fromJson(json as Map<String, dynamic>),
    );

    emit(CustomerServiceSuccess(rebuilt));
  }

  Future<void> addService({required bool isEdit, int? serviceId}) async {
    if (isEdit && serviceId != null) {
      addServiceModel = addServiceModel.copyWith(id: serviceId);
    }
    emit(AddrServiceLoading());
    try {
      await customerServiceRepo.addService(
        addServiceModel,
        isEdit: isEdit,
      );
      final successMessage =
      isEdit ? "edit_service_success".tr() : "add_service_success".tr();
      emit(AddrServiceSuccess(successMessage));
    } catch (e) {
      emit(AddrServiceFail(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
