part of 'admins_service.dart';

@Injectable(as: AdminsService)
class AdminsServiceImp implements AdminsService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<AdminModel>> getAdmins(
    int page, {
    String? startDate,
    String? endDate,
    String? role,
  }) async {
    try {
      const perPageParam = "per_page=10";
      final pageParam = "page=$page";
      final roleParam = role != null ? "role=$role" : "";
      final startDateParam = startDate != null ? "startDate=$startDate" : "";
      final endDateParam = endDate != null ? "endDate=$endDate" : "";
      final response = await dio.get(
        "/admin_api/show_users?$roleParam&$pageParam&$perPageParam&$startDateParam&$endDateParam",
      );
      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => AdminModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PermissionModel>> getPermissions() async {
    try {
      final response = await dio.get("/superAdmin_api/permissions?role=admin");
      final permissionsJson = response.data as List;

      return List.generate(
        permissionsJson.length,
        (index) => PermissionModel.fromJson(
          permissionsJson[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateAdmin(
    UpdateAdminModel updateAdminModel, {
    required bool isEdit,
  }) async {
    final url = isEdit ? "update" : "add";
    try {
      final categories = updateAdminModel.categories;
      final map = {
        'id': updateAdminModel.id,
        'name': updateAdminModel.name,
        'user_name': updateAdminModel.username,
        'password': updateAdminModel.password,
        'mobile': updateAdminModel.mobile,
        'type_id': updateAdminModel.typeId,
        'role': updateAdminModel.role,
      };
      if (categories != null) {
        for (var i = 0; i < categories.length; i++) {
          map.addAll({
            'category[$i]': categories[i],
          });
        }
      }
      final formData = FormData.fromMap(map);

      await dio.post(
        "/admin_api/${url}_user",
        data: formData,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserTypeModel>> getUserTypes() async {
    try {
      final response = await dio.get("/admin_api/types");
      final userTypes = response.data["data"] as List;

      return List.generate(
        userTypes.length,
        (index) => UserTypeModel.fromJson(
          userTypes[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserTypeModel>> getUserRoles() async {
    try {
      final response = await dio.get("/admin_api/roles");
      final userTypes = response.data as List;

      return List.generate(
        userTypes.length,
        (index) => UserTypeModel.fromJson(
          userTypes[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesSubInItem() async {
    try {
      final response = await dio.get("/admin_api/show_categories_sub_in_item");
      final categories = response.data["data"] as List;

      return List.generate(
        categories.length,
        (index) => CategoryModel.fromJson(
          categories[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
