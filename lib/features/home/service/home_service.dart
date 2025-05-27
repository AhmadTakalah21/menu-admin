import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/features/home/model/edit_category_model/edit_category_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';

part 'home_service_imp.dart';

abstract class HomeService {
  Future<List<CategoryModel>> getCategories({int? categoryId});

  Future<List<CategoryModel>> getCategoriesSub();

  Future<CategoryModel> editCategory(
    EditCategoryModel editCategoryModel,
    XFile? image, {
    required bool isEdit,
  });
}
