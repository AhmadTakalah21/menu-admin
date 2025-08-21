import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/features/admins/model/permission_model/permission_model.dart';
import 'package:user_admin/features/admins/model/update_admin_model/update_admin_model.dart';
import 'package:user_admin/features/admins/model/user_type_model/user_type_model.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'admins_service_imp.dart';

abstract class AdminsService {
  Future<PaginatedModel<AdminModel>> getAdmins(
    int page, {
    String? startDate,
    String? endDate,
    int? type,
    //String? role,
  });

  Future<List<PermissionModel>> getPermissions();

  Future<void> updateAdmin(
    UpdateAdminModel updateAdminModel, {
    required bool isEdit,
  });

  Future<List<UserTypeModel>> getUserTypes();

  Future<List<UserTypeModel>> getUserRoles();

  Future<List<CategoryModel>> getCategoriesSubInItem();
}
