import 'package:injectable/injectable.dart';
import 'package:user_admin/features/customer_service/model/add_service_model/add_service_model.dart';
import 'package:user_admin/features/customer_service/model/service_model/service_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part "customer_service_repo_imp.dart";

abstract class CustomerServiceRepo {
  Future<PaginatedModel<ServiceModel>> getServices({int? page});

  Future<void> addService(
    AddServiceModel addServiceModel, {
    required bool isEdit,
  });
}
