import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/users/model/edit_user_model/edit_user_model.dart';
import 'package:user_admin/features/users/model/user_model/user_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'users_service_imp.dart';

abstract class UsersService {
  Future<PaginatedModel<UserModel>> getUsers(int page);

  Future<void> editUser(EditUserModel editUserModel, String? password);

  Future<PaginatedModel<DrvierInvoiceModel>> getUserInvoices(int id, int page);
}
