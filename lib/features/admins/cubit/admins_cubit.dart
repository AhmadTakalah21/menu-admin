import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/features/admins/model/permission_model/permission_model.dart';
import 'package:user_admin/features/admins/model/update_admin_model/update_admin_model.dart';
import 'package:user_admin/features/admins/model/user_type_model/user_type_model.dart';
import 'package:user_admin/features/admins/service/admins_service.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/utils/constants.dart';

part 'states/admins_state.dart';
part 'states/permissions_state.dart';
part 'states/update_admin_state.dart';
part 'states/general_admins_state.dart';
part 'states/user_types_state.dart';
//part 'states/user_roles_state.dart';
part 'states/categories_sub_in_item_state.dart';

@injectable
class AdminsCubit extends Cubit<GeneralAdminsState> {
  AdminsCubit(this.adminsService) : super(GeneralAdminsInitial());

  final AdminsService adminsService;
  UpdateAdminModel updateAdminModel = const UpdateAdminModel();

  PaginatedModel<AdminModel>? _adminsCache;

  UserTypeModel? type;
  String? startDate;
  String? endDate;

  List<int> categoryIds = [];

  void setId(int id) {
    updateAdminModel = updateAdminModel.copyWith(id: id);
  }

  void setName(String? name) {
    updateAdminModel = updateAdminModel.copyWith(name: name);
  }

  void setUsername(String? username) {
    updateAdminModel = updateAdminModel.copyWith(username: username);
  }

  void setEmail(String? email) {
    updateAdminModel = updateAdminModel.copyWith(email: email);
  }

  void setPassword(String? password) {
    updateAdminModel = updateAdminModel.copyWith(password: password);
  }

  void setMobile(String? mobile) {
    updateAdminModel = updateAdminModel.copyWith(mobile: mobile);
  }

  void setUserType(int? typeId) {
    updateAdminModel = updateAdminModel.copyWith(typeId: typeId);
  }

  void setCategories(CategoryModel? category) {
    if (category != null) {
      int index = categoryIds.indexWhere(
            (categoryId) => categoryId == category.id,
      );
      if (index == -1) {
        categoryIds.add(category.id);
      } else {
        categoryIds.remove(category.id);
      }
    } else {
      categoryIds.clear();
    }
    updateAdminModel = updateAdminModel.copyWith(categories: categoryIds);
  }

  // void setRole(RoleEnum? role) {
  //   this.role = role;
  // }

  void setUserTypeFilter(UserTypeModel? type) {
    this.type = type;
  }

  void setStartDate(String? startDate) {
    this.startDate = startDate;
  }

  void setEndDate(String? endDate) {
    this.endDate = endDate;
  }

  Future<void> getAdmins(int page) async {
    // String? roleStrig;
    // if (role == RoleEnum.all) {
    //   roleStrig = null;
    // } else {
    //   roleStrig = role?.name;
    // }

    emit(AdminsLoading());
    try {
      final response = await adminsService.getAdmins(
        page,
        //role: roleStrig,
        type: type?.id,
        startDate: startDate,
        endDate: endDate,
      );

      _adminsCache = response;

      if (response.data.isEmpty) {
        emit(AdminsEmpty("no_admins".tr()));
      } else {
        emit(AdminsSuccess(response));
      }
    } catch (e) {
      emit(AdminsFail(e.toString()));
    }
  }

  void searchByName(String query) {
    final q = query.trim().toLowerCase();
    if (_adminsCache == null) return;

    if (q.isEmpty) {
      emit(AdminsSuccess(_adminsCache!));
      return;
    }

    final filtered = _adminsCache!.data.where((a) {
      final name = a.name.toLowerCase();
      // لو أردت تضمين اسم المستخدم أيضاً:
      // final username = a.username.toLowerCase();
      // return name.contains(q) || username.contains(q);
      return name.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      emit(AdminsEmpty("no_admins".tr()));
    } else {
      final paged = PaginatedModel<AdminModel>(
        data: filtered,
        meta: _adminsCache!.meta,
      );
      emit(AdminsSuccess(paged));
    }
  }

  void clearSearch() {
    if (_adminsCache != null) {
      emit(AdminsSuccess(_adminsCache!));
    }
  }

  Future<void> getPermissions() async {
    emit(PermissionsLoading());
    try {
      final response = await adminsService.getPermissions();
      if (response.isEmpty) {
        emit(PermissionsEmpty("no_permissions".tr()));
      } else {
        emit(PermissionsSuccess(response));
      }
    } catch (e) {
      emit(PermissionsFail(e.toString()));
    }
  }

  Future<void> updateAdmin({int? adminAd, required bool isEdit}) async {
    if (isEdit && adminAd != null) {
      setId(adminAd);
    }
    emit(UpdateAdminLoading());
    try {
      await adminsService.updateAdmin(updateAdminModel, isEdit: isEdit);

      emit(UpdateAdminSuccess("admin_updated".tr()));
      categoryIds.clear();
    } catch (e) {
      emit(UpdateAdminFail(e.toString()));
    }
  }

  Future<void> getUserTypes({required bool isRefresh}) async {
    final prefs = await SharedPreferences.getInstance();
    const resId = AppConstants.restaurantId;

    final tString = prefs.getStringList("${resId}user_types");
    if (tString != null && !isRefresh) {
      final types = tString.map((e) => UserTypeModel.fromString(e)).toList();
      if (isClosed) return;
      emit(UserTypesSuccess(types));
      return;
    }
    if (isClosed) return;
    emit(UserTypesLoading());
    try {
      if (isClosed) return;
      final types = await adminsService.getUserTypes();
      emit(UserTypesSuccess(types));
      final typesString = types.map((e) => e.toString()).toList();

      prefs.setStringList("${resId}user_types", typesString);
    } catch (e) {
      if (isClosed) return;
      emit(UserTypesFail(e.toString()));
    }
  }

  // Future<void> getUserRoles({required bool isRefresh}) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   final userRolesString = prefs.getStringList(
  //     "${AppConstants.restaurantId}user_roles",
  //   );
  //   if (userRolesString != null && !isRefresh) {
  //     List<UserTypeModel> userRoles = List.generate(
  //       userRolesString.length,
  //       (index) => UserTypeModel.fromString(
  //         userRolesString[index],
  //       ),
  //     );
  //     emit(UserRolesSuccess(userRoles));
  //     return;
  //   }
  //   emit(UserRolesLoading());
  //   try {
  //     final userRoles = await adminsService.getUserRoles();
  //     emit(UserRolesSuccess(userRoles));
  //     final userRolesString = List.generate(
  //       userRoles.length,
  //       (index) => userRoles[index].toString(),
  //     );
  //     prefs.setStringList(
  //       "${AppConstants.restaurantId}user_roles",
  //       userRolesString,
  //     );
  //   } catch (e) {
  //     emit(UserRolesFail(e.toString()));
  //   }
  // }

  Future<void> getCategoriesSubInItem({required bool isRefresh}) async {
    final prefs = await SharedPreferences.getInstance();

    final categoriesString = prefs.getStringList(
      "${AppConstants.restaurantId}categories_sub_in_item",
    );
    if (categoriesString != null && !isRefresh) {
      List<CategoryModel> categories = List.generate(
        categoriesString.length,
            (index) => CategoryModel.fromString(
          categoriesString[index],
        ),
      );
      if (categories.isEmpty) {
        emit(CategoriesSubInItemEmpty("no_categories".tr()));
      } else {
        emit(CategoriesSubInItemSuccess(categories));
      }
      return;
    }
    emit(CategoriesSubInItemLoading());
    try {
      final categories = await adminsService.getCategoriesSubInItem();
      if (categories.isEmpty) {
        emit(CategoriesSubInItemEmpty("no_categories".tr()));
      } else {
        emit(CategoriesSubInItemSuccess(categories));
      }

      final categoriesString = List.generate(
        categories.length,
            (index) => categories[index].toString(),
      );
      prefs.setStringList(
        "${AppConstants.restaurantId}categories_sub_in_item",
        categoriesString,
      );
    } catch (e) {
      emit(CategoriesSubInItemFail(e.toString()));
    }
  }
}
