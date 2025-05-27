import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/drivers/model/add_driver_model/add_driver_model.dart';
import 'package:user_admin/features/drivers/model/driver_model/driver_model.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/drivers/service/drivers_service.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'states/drivers_state.dart';

part 'states/driver_invoices_state.dart';

part 'states/add_driver_state.dart';

part 'states/general_drivers_state.dart';

@injectable
class DriversCubit extends Cubit<GeneralDriversState> {
  DriversCubit(this.driversService) : super(GeneralDriversInitial());
  final DriversService driversService;

  AddDriverModel addDriverModel = const AddDriverModel();
  XFile? image;

  setName(String? name) {
    addDriverModel = addDriverModel.copyWith(name: name);
  }

  setUsername(String? username) {
    addDriverModel = addDriverModel.copyWith(username: username);
  }

  setPassword(String? password) {
    addDriverModel = addDriverModel.copyWith(password: password);
  }

  setPhone(String? phone) {
    addDriverModel = addDriverModel.copyWith(phone: phone);
  }

  setBirthday(String? birthday) {
    addDriverModel = addDriverModel.copyWith(birthday: birthday);
  }

  setRestaurantId(int restaurantId) {
    addDriverModel = addDriverModel.copyWith(restaurantId: restaurantId);
  }

  setId(int? id) {
    addDriverModel = addDriverModel.copyWith(id: id);
  }

  Future<void> setImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    this.image = image;
  }

  Future<void> getDrivers({
    required bool isActive,
    required bool isRefresh,
    int? page,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("drivers$isActive");

    if (data != null && !isRefresh) {
      final drivers = PaginatedModel.fromString(
        data,
        (json) => DriverModel.fromJson(json as Map<String, dynamic>),
      );
      if (drivers.data.isEmpty) {
        emit(DriversEmpty("no_drivers".tr()));
      } else {
        emit(DriversSuccess(drivers));
      }
      return;
    }

    emit(DriversLoading());
    try {
      final drivers = await driversService.getDrivers(
        isActive: isActive,
        page: page,
      );

      prefs.setString("drivers$isActive", drivers.toString());

      if (drivers.data.isEmpty) {
        emit(DriversEmpty("no_drivers".tr()));
      } else {
        emit(DriversSuccess(drivers));
      }
    } catch (e) {
      emit(DriversFail(e.toString()));
    }
  }

  Future<void> addDriver(
    int restaurantId, {
    required bool isEdit,
    int? driverId,
  }) async {
    setRestaurantId(restaurantId);
    if (isEdit && driverId != null) {
      setId(driverId);
    }

    emit(AddDriverLoading());
    try {
      await driversService.addDriver(
        addDriverModel,
        isEdit: isEdit,
      );
      final successMessage =
          isEdit ? "edit_driver_success".tr() : "add_driver_success".tr();
      emit(AddDriverSuccess(successMessage));
      addDriverModel = const AddDriverModel();
    } catch (e) {
      emit(AddDriverFail(e.toString()));
    }
  }

  Future<void> getDriverInvoices(int driverId, {int? page}) async {
    emit(DriverInvoicesLoading());
    try {
      final invoices = await driversService.getDriverInvoices(
        driverId,
        page: page,
      );
      if (invoices.data.isEmpty) {
        emit(DriverInvoicesEmpty("no_invoices".tr()));
      } else {
        emit(DriverInvoicesSuccess(invoices));
      }
    } catch (e) {
      emit(DriverInvoicesFail(e.toString()));
    }
  }
}
