part of 'users_service.dart';

@Injectable(as: UsersService)
class UsersServiceImp implements UsersService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<UserModel>> getUsers(int page) async {
    const perPageParam = "per_page=10";
    try {
      final response = await dio.get(
        "/admin_api/show_users_takeout?page=$page&$perPageParam",
      );
      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => UserModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editUser(EditUserModel editUserModel, String? password) async {
    try {
      final map = editUserModel.toJson();
      if (password != null) {
        map.addAll({"password": password});
      }
      await dio.post(
        "/admin_api/update_user_takeout",
        data: FormData.fromMap(map),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedModel<DrvierInvoiceModel>> getUserInvoices(
    int id,
    int page,
  ) async {
    const perPageParam = "per_page=10";
    try {
      final response = await dio.get(
        "/admin_api/show_orders_user?id=$id&page=$page&$perPageParam",
      );
      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => DrvierInvoiceModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
