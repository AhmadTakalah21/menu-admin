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

  /// كاش للبحث المحلي
  List<CategoryModel>? _rootCategoriesCache; // الفئات الرئيسية (categoryId == null)
  final Map<int, List<CategoryModel>> _subInMasterCache = {}; // فروع لكل parent
  List<CategoryModel>? _subListCache; // نتيجة getCategoriesSub()

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
        if (localSubCategories.isEmpty) {
          emit(SubCategoriesEmpty("no_subcategories".tr()));
        } else {
          emit(SubCategoriesSuccess(localSubCategories));
        }
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

      // حدّث الكاش للبحث المحلي
      if (categoryId == null) {
        _rootCategoriesCache = categories;
      } else {
        _subInMasterCache[categoryId] = categories;
      }

      if (categories.isEmpty) {
        emit(categoryId == null
            ? CategoriesEmpty("no_categories".tr())
            : SubCategoriesInMasterEmpty("no_subcategories".tr()));
      } else {
        emit(categoryId == null
            ? CategoriesSuccess(categories)
            : SubCategoriesInMasterSuccess(categories));
      }
      return;
    }

    emit(categoryId == null
        ? CategoriesLoading()
        : SubCategoriesInMasterLoading());

    try {
      final categories =
      await homeService.getCategories(categoryId: categoryId);

      // خزّن في SharedPreferences
      final encoded = categories.map((e) => e.toString()).toList();
      prefs.setStringList("cafe_categories_$categoryId", encoded);

      // حدّث الكاش للبحث المحلي
      if (categoryId == null) {
        _rootCategoriesCache = categories;
      } else {
        _subInMasterCache[categoryId] = categories;
      }

      if (categories.isEmpty) {
        emit(categoryId == null
            ? CategoriesEmpty("no_categories".tr())
            : SubCategoriesInMasterEmpty("no_subcategories".tr()));
      } else {
        emit(categoryId == null
            ? CategoriesSuccess(categories)
            : SubCategoriesInMasterSuccess(categories));
      }
    } catch (e) {
      emit(categoryId == null
          ? CategoriesFail(e.toString())
          : SubCategoriesInMasterFail(e.toString()));
    }
  }

  Future<void> getCategoriesSub({required bool isRefresh}) async {
    if (localSubCategories != null && !isRefresh) {

      _subListCache = localSubCategories;

      if (localSubCategories!.isEmpty) {
        emit(SubCategoriesEmpty("no_subcategories".tr()));
      } else {
        emit(SubCategoriesSuccess(localSubCategories!));
      }
      return;
    }

    emit(SubCategoriesLoading());

    try {
      final categories = await homeService.getCategoriesSub();
      localSubCategories = categories;

      // حدّث كاش البحث
      _subListCache = categories;

      if (categories.isEmpty) {
        emit(SubCategoriesEmpty("no_"));
      } else {
        emit(SubCategoriesSuccess(categories));
      }
    } catch (e) {
      emit(SubCategoriesFail(e.toString()));
    }
  }

  // =========================
  // البحث المحلي بالاسم (بدون API)
  // =========================

  /// بحث في الفئات الرئيسية (categoryId == null) أو فروع master (بتمرير parentId)
  void searchCategoriesByName(String query, {int? parentId}) {
    final q = query.trim().toLowerCase();

    // اختيار مصدر البيانات بحسب السياق
    final List<CategoryModel>? source =
    parentId == null ? _rootCategoriesCache : _subInMasterCache[parentId];

    if (source == null) return;

    if (q.isEmpty) {
      // رجّع الأصل
      if (parentId == null) {
        emit(CategoriesSuccess(source));
      } else {
        emit(SubCategoriesInMasterSuccess(source));
      }
      return;
    }

    final filtered = source.where((c) {
      final name = (c.name).toLowerCase();
      final nameAr = (c.nameAr ?? '').toLowerCase();
      final nameEn = (c.nameEn ?? '').toLowerCase();
      return name.contains(q) || nameAr.contains(q) || nameEn.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      if (parentId == null) {
        emit(CategoriesEmpty("no_categories".tr()));
      } else {
        emit(SubCategoriesInMasterEmpty("no_subcategories".tr()));
      }
    } else {
      if (parentId == null) {
        emit(CategoriesSuccess(filtered));
      } else {
        emit(SubCategoriesInMasterSuccess(filtered));
      }
    }
  }

  /// إلغاء بحث الفئات (رئيسية/داخل master)
  void clearCategoriesSearch({int? parentId}) {
    final List<CategoryModel>? source =
    parentId == null ? _rootCategoriesCache : _subInMasterCache[parentId];
    if (source == null) return;

    if (parentId == null) {
      emit(CategoriesSuccess(source));
    } else {
      emit(SubCategoriesInMasterSuccess(source));
    }
  }

  /// بحث لقائمة getCategoriesSub() (قائمة فرعية عامة)
  void searchSubListByName(String query) {
    final q = query.trim().toLowerCase();
    final source = _subListCache ?? localSubCategories;
    if (source == null) return;

    if (q.isEmpty) {
      emit(SubCategoriesSuccess(source));
      return;
    }

    final filtered = source.where((c) {
      final name = (c.name).toLowerCase();
      final nameAr = (c.nameAr ?? '').toLowerCase();
      final nameEn = (c.nameEn ?? '').toLowerCase();
      return name.contains(q) || nameAr.contains(q) || nameEn.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      emit(SubCategoriesEmpty("no_subcategories".tr()));
    } else {
      emit(SubCategoriesSuccess(filtered));
    }
  }

  /// إلغاء بحث قائمة getCategoriesSub()
  void clearSubListSearch() {
    final source = _subListCache ?? localSubCategories;
    if (source == null) return;
    emit(SubCategoriesSuccess(source));
  }
}
