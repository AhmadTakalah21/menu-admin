import 'dart:async';
import 'dart:convert';
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

  // ▼▼▼ إضافة: حالة البحث + ديباونس + آخر فلاتر ▼▼▼
  String _searchQuery = '';
  Timer? _debounce;
  bool _lastIsActive = false;
  int _lastPage = 1;
  // ▲▲▲

  setName(String? name)   => addDriverModel = addDriverModel.copyWith(name: name);
  setUsername(String? u)  => addDriverModel = addDriverModel.copyWith(username: u);
  setPassword(String? p)  => addDriverModel = addDriverModel.copyWith(password: p);
  setPhone(String? phone) => addDriverModel = addDriverModel.copyWith(phone: phone);
  setBirthday(String? b)  => addDriverModel = addDriverModel.copyWith(birthday: b);
  setRestaurantId(int id) => addDriverModel = addDriverModel.copyWith(restaurantId: id);
  setId(int? id)          => addDriverModel = addDriverModel.copyWith(id: id);

  Future<void> setImage() async {
    final picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
  }

  // 🔍 يُستدعى من الـAppBar
  void searchByName(String q) {
    _searchQuery = q.trim();
    _lastPage = 1;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      getDrivers(isActive: _lastIsActive, isRefresh: true, page: _lastPage);
    });
  }

  // لمسح البحث عند إغلاق شريط البحث
  void clearSearch() {
    if (_searchQuery.isEmpty) return;
    _searchQuery = '';
    _lastPage = 1;
    getDrivers(isActive: _lastIsActive, isRefresh: true, page: _lastPage);
  }

  Future<void> getDrivers({
    required bool isActive,
    required bool isRefresh,
    int? page,
  }) async {
    _lastIsActive = isActive;
    _lastPage = page ?? 1;

    final prefs = await SharedPreferences.getInstance();

    // عند عدم وجود بحث: نستخدم الكاش إن وجد وكان isRefresh=false
    if (_searchQuery.isEmpty) {
      final data = prefs.getString("drivers$isActive");
      if (data != null && !isRefresh) {
        final drivers = PaginatedModel.fromString(
          data,
              (json) => DriverModel.fromJson(json as Map<String, dynamic>),
        );
        return _emitWithFilter(drivers); // سيُمرّر بدون فلترة
      }
    }

    emit(DriversLoading());
    try {
      final drivers = await driversService.getDrivers(
        isActive: isActive,
        page: page,
      );

      // نخزن النسخة الكاملة فقط عندما لا يوجد بحث
      if (_searchQuery.isEmpty) {
        prefs.setString("drivers$isActive", drivers.toString());
      }

      _emitWithFilter(drivers);
    } catch (e) {
      emit(DriversFail(e.toString()));
    }
  }

  // فلترة محلية آمنة حتى لو الـAPI لا يدعم search
  void _emitWithFilter(PaginatedModel<DriverModel> source) {
    if (_searchQuery.isEmpty) {
      if (source.data.isEmpty) {
        emit(DriversEmpty("no_drivers".tr()));
      } else {
        emit(DriversSuccess(source));
      }
      return;
    }

    final q = _searchQuery.toLowerCase();
    final filtered = source.data.where((d) {
      return d.name.toLowerCase().contains(q) ||
          d.username.toLowerCase().contains(q) ||
          d.phone.toLowerCase().contains(q);
    }).toList();

    if (filtered.isEmpty) {
      emit(DriversEmpty("no_drivers".tr()));
      return;
    }

    // 🧠 حيلة لإعادة بناء PaginatedModel بنفس الـmeta ولكن ببيانات مفلترة
    final srcMap = json.decode(source.toString()) as Map<String, dynamic>;
    srcMap['data'] = filtered.map((e) => e.toJson()).toList();
    final rebuilt = PaginatedModel.fromString(
      json.encode(srcMap),
          (json) => DriverModel.fromJson(json as Map<String, dynamic>),
    );

    emit(DriversSuccess(rebuilt));
  }

  Future<void> addDriver(
      int restaurantId, {
        required bool isEdit,
        int? driverId,
      }) async {
    setRestaurantId(restaurantId);
    if (isEdit && driverId != null) setId(driverId);

    emit(AddDriverLoading());
    try {
      await driversService.addDriver(addDriverModel, isEdit: isEdit);
      emit(AddDriverSuccess(isEdit ? "edit_driver_success".tr() : "add_driver_success".tr()));
      addDriverModel = const AddDriverModel();
    } catch (e) {
      emit(AddDriverFail(e.toString()));
    }
  }

  Future<void> getDriverInvoices(int driverId, {int? page}) async {
    emit(DriverInvoicesLoading());
    try {
      final invoices = await driversService.getDriverInvoices(driverId, page: page);
      if (invoices.data.isEmpty) {
        emit(DriverInvoicesEmpty("no_invoices".tr()));
      } else {
        emit(DriverInvoicesSuccess(invoices));
      }
    } catch (e) {
      emit(DriverInvoicesFail(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
