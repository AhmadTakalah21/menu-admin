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
    emit(CustomerServiceLoading());
    try {
      final services = await customerServiceRepo.getServices(page: page);
      if (services.data.isEmpty) {
        emit(CustomerServiceEmpty("no_services".tr()));
      } else {
        emit(CustomerServiceSuccess(services));
      }
    } catch (e) {
      emit(CustomerServiceFail(e.toString()));
    }
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
}
