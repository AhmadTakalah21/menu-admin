import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/users/model/edit_user_model/edit_user_model.dart';
import 'package:user_admin/features/users/model/user_model/user_model.dart';
import 'package:user_admin/features/users/service/users_service.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'states/users_state.dart';
part 'states/user_invoices_state.dart';
part 'states/edit_user_state.dart';
part 'states/general_users_state.dart';

@injectable
class UsersCubit extends Cubit<GeneralUsersState> {
  UsersCubit(this.usersService) : super(GeneralUsersInitial());
  final UsersService usersService;

  EditUserModel editUserModel = const EditUserModel();
  String? password;

  PaginatedModel<UserModel>? _usersCache;

  setName(String name) {
    editUserModel = editUserModel.copyWith(name: name);
  }

  setUsername(String username) {
    editUserModel = editUserModel.copyWith(username: username);
  }

  setPassword(String password) {
    this.password = password;
  }

  setPhone(String phone) {
    editUserModel = editUserModel.copyWith(phone: phone);
  }

  setRestaurantId(int restaurantId) {
    editUserModel = editUserModel.copyWith(restaurantId: restaurantId);
  }

  setId(int id) {
    editUserModel = editUserModel.copyWith(id: id);
  }

  Future<void> getUsers(int page) async {
    emit(UsersLoading());
    try {
      final response = await usersService.getUsers(page);
      _usersCache = response;

      if (response.data.isEmpty) {
        emit(UsersEmpty("no_users".tr()));
      } else {
        emit(UsersSuccess(response));
      }
    } catch (e) {
      emit(UsersFail(e.toString()));
    }
  }

  Future<void> editUser({
    required int restaurantId,
    required int driverId,
  }) async {
    final password = this.password;
    setRestaurantId(restaurantId);
    setId(driverId);
    if (password != null && password.isNotEmpty && password.length < 8) {
      emit(EditUserFail("password_short".tr()));
      return;
    }
    if (password != null && password.isEmpty) {
      this.password = null;
    }
    emit(EditUserLoading());
    try {
      await usersService.editUser(editUserModel, this.password);
      emit(EditUserSuccess("edit_driver_success".tr()));
      editUserModel = const EditUserModel();
      this.password = null;
    } catch (e) {
      emit(EditUserFail(e.toString()));
    }
  }

  Future<void> getUserInvoices(int id, int page) async {
    emit(UserInvoicesLoading());
    try {
      final response = await usersService.getUserInvoices(id, page);
      if (response.data.isEmpty) {
        emit(UserInvoicesEmpty("no_invoices".tr()));
      } else {
        emit(UserInvoicesSuccess(response));
      }
    } catch (e) {
      emit(UserInvoicesFail(e.toString()));
    }
  }

  void searchByName(String query) {
    final q = query.trim().toLowerCase();
    if (_usersCache == null) return;

    if (q.isEmpty) {
      emit(UsersSuccess(_usersCache!));
      return;
    }

    final filtered = _usersCache!.data.where((u) {
      final name = (u.name).toLowerCase();
      final username = (u.username).toLowerCase();
      return name.contains(q) || username.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      emit(UsersEmpty("no_users".tr()));
    } else {
      final paged = PaginatedModel<UserModel>(
        data: filtered,
        meta: _usersCache!.meta,
      );
      emit(UsersSuccess(paged));
    }
  }

  void clearSearch() {
    if (_usersCache != null) {
      emit(UsersSuccess(_usersCache!));
    }
  }
}
