import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/features/home/model/edit_category_model/edit_category_model.dart';
import 'package:user_admin/features/home/service/home_service.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';

part 'states/home_state.dart';

part 'states/categories_state.dart';

part 'states/edit_category_state.dart';

part 'states/sub_categories_state.dart';

part 'states/sub_categories_in_master_state.dart';

part 'states/image_state.dart';


@injectable
class HomeCubit extends Cubit<GeneralHomeState> {
  HomeCubit(this.homeService) : super(GeneralHomeInitial());

  final HomeService homeService;

  EditCategoryModel editCategoryModel = const EditCategoryModel();
  List<CategoryModel>? localSubCategories;

  /// ❌ لم نعد نستخدم image هنا مباشرة
  // XFile? image;

  void setCategory(CategoryModel? category) {
    if (category == null) return;
    editCategoryModel = editCategoryModel.copyWith(
      id: category.id,
      nameAr: category.nameAr,
      nameEn: category.nameEn,
      categoryId: category.categoryId,
      image: category.image,
    );
  }

  void setNameAr(String? nameAr) {
    editCategoryModel = editCategoryModel.copyWith(nameAr: nameAr);
  }

  void setNameEn(String? nameEn) {
    editCategoryModel = editCategoryModel.copyWith(nameEn: nameEn);
  }

  void setCategoryId(int? categoryId) {
    editCategoryModel = editCategoryModel.copyWith(categoryId: categoryId);
  }

  /// ✅ اختيار صورة فقط بدون تخزينها مباشرة في المتغير العام
  Future<XFile?> pickImage() async {
    try {
      emit(ImageLoading());
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        emit(ImageUpdated(picked));
        return picked;
      } else {
        emit(ImageInitial());
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
    return null;
  }

  /// ✅ التعديل ليأخذ الصورة بشكل وسيط من الشاشة فقط
  Future<void> editCategory({
    required bool isEdit,
    int? categoryId,
    XFile? imageFile,
  }) async {
    final localSubCategories = this.localSubCategories;

    if (isEdit) {
      setCategoryId(categoryId);
    } else {
      setCategoryId(null);
    }

    if (editCategoryModel.id == null && isEdit) {
      emit(EditCategoryFail("category_empty".tr()));
      return;
    }

    emit(EditCategoryLoading());

    try {
      final editedCategory = await homeService.editCategory(
        editCategoryModel,
        imageFile,
        isEdit: isEdit,
      );

      final successMessage =
      isEdit ? "edit_category_success".tr() : "add_category_success".tr();

      emit(EditCategorySuccess(editedCategory, successMessage));

      if (localSubCategories != null && isEdit) {
        emit(SubCategoriesSuccess(localSubCategories));
      }
    } catch (e) {
      emit(EditCategoryFail(e.toString()));
    }
  }

  bool isShowItems(List<RoleModel> permissions) {
    return permissions.any((e) => e.name == "item.index");
  }

  Future<void> getCategories({
    int? categoryId,
    required bool isRefresh,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("cafe_categories_$categoryId");

    if (data != null && !isRefresh) {
      final categories = data.map(CategoryModel.fromString).toList();
      emit(categoryId == null
          ? CategoriesSuccess(categories)
          : SubCategoriesInMasterSuccess(categories));
      return;
    }

    emit(categoryId == null
        ? CategoriesLoading()
        : SubCategoriesInMasterLoading());

    try {
      final response = await homeService.getCategories(categoryId: categoryId);
      final encoded = response.map((e) => e.toString()).toList();
      prefs.setStringList("cafe_categories_$categoryId", encoded);
      emit(categoryId == null
          ? CategoriesSuccess(response)
          : SubCategoriesInMasterSuccess(response));
    } catch (e) {
      emit(categoryId == null
          ? CategoriesFail(e.toString())
          : SubCategoriesInMasterFail(e.toString()));
    }
  }

  Future<void> getCategoriesSub({required bool isRefresh}) async {
    if (localSubCategories != null && !isRefresh) {
      emit(SubCategoriesSuccess(localSubCategories!));
      return;
    }

    emit(SubCategoriesLoading());

    try {
      final response = await homeService.getCategoriesSub();
      localSubCategories = response;
      emit(SubCategoriesSuccess(response));
    } catch (e) {
      emit(SubCategoriesFail(e.toString()));
    }
  }
}
