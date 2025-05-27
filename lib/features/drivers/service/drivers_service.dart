import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/drivers/model/add_driver_model/add_driver_model.dart';
import 'package:user_admin/features/drivers/model/driver_model/driver_model.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'drivers_service_imp.dart';

abstract class DriversService {
  Future<PaginatedModel<DriverModel>> getDrivers({
    required bool isActive,
    int? page,
  });

  Future<void> addDriver(
    AddDriverModel addDriverModel, {
    required bool isEdit,
    XFile? image,
  });

  Future<PaginatedModel<DrvierInvoiceModel>> getDriverInvoices(
    int driverId, {
    int? page,
  });
}
