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
  XFile? image;

  void setCategory(CategoryModel? category) {
    editCategoryModel = editCategoryModel.copyWith(id: category?.id);
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

  Future<void> setImage() async {
    try {
      emit(ImageLoading());
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        this.image = image;
        emit(ImageUpdated(image));
        // للحفاظ على حالة الفئات الحالية
        if (state is CategoriesSuccess) {
          emit(CategoriesSuccess((state as CategoriesSuccess).categories));
        }
      }
    } catch (e) {
      emit(ImageError(e.toString()));
      // استعادة الحالة السابقة
      if (state is CategoriesSuccess) {
        emit(CategoriesSuccess((state as CategoriesSuccess).categories));
      }
    }
  }


  bool isShowItems(List<RoleModel> permissions) {
    int index = permissions.indexWhere(
      (element) => element.name == "item.index",
    );
    return index != -1;
  }

  Future<void> getCategories({
    int? categoryId,
    required bool isRefresh,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("cafe_categories_$categoryId");

    if (data != null && !isRefresh) {
      List<CategoryModel> categories;
      categories = List.generate(
        data.length,
        (index) => CategoryModel.fromString(data[index]),
      );
      if (categoryId == null) {
        emit(CategoriesSuccess(categories));
      } else {
        emit(SubCategoriesInMasterSuccess(categories));
      }
      return;
    } else {
      if (categoryId == null) {
        emit(CategoriesLoading());
      } else {
        emit(SubCategoriesInMasterLoading());
      }

      try {
        final response = await homeService.getCategories(
          categoryId: categoryId,
        );

        List<String> categoriesString;
        categoriesString = List.generate(
          response.length,
          (index) => response[index].toString(),
        );
        prefs.setStringList(
          "cafe_categories_$categoryId",
          categoriesString,
        );

        if (categoryId == null) {
          emit(CategoriesSuccess(response));
        } else {
          emit(SubCategoriesInMasterSuccess(response));
        }
      } catch (e) {
        if (categoryId == null) {
          emit(CategoriesFail(e.toString()));
        } else {
          emit(SubCategoriesInMasterFail(e.toString()));
        }
      }
    }
  }

  Future<void> getCategoriesSub({required bool isRefresh}) async {
    final localSubCategories = this.localSubCategories;
    if (localSubCategories != null && !isRefresh) {
      emit(SubCategoriesSuccess(localSubCategories));
      return;
    }
    emit(SubCategoriesLoading());

    try {
      final response = await homeService.getCategoriesSub();
      emit(SubCategoriesSuccess(response));
      this.localSubCategories = response;
    } catch (e) {
      emit(SubCategoriesFail(e.toString()));
    }
  }

  Future<void> editCategory({required bool isEdit, int? categoryId}) async {
    final localSubCategories = this.localSubCategories;
    setCategoryId(categoryId);

    if (editCategoryModel.id == null && isEdit) {
      emit(EditCategoryFail("category_empty".tr()));
      return;
    }
    emit(EditCategoryLoading());

    try {
      final editedCategory = await homeService.editCategory(
        editCategoryModel,
        image,
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
}
