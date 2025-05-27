import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/items/model/add_component_item_model/add_component_item_model.dart';
import 'package:user_admin/features/items/model/add_extra_item_model/add_extra_item_model.dart';
import 'package:user_admin/features/items/model/add_size_item_model/add_size_item_model.dart';
import 'package:user_admin/features/items/model/edit_item_model/edit_item_model.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';

import '../model/add_nutrition_item_model/add_nutrition_item_model.dart';

part 'items_service_imp.dart';

abstract class ItemsService {
  Future<List<ItemModel>> getItems({
    int? categoryId,
    int? restaurantId,
    int perPage = 1000,
  });

  Future<ItemModel> editItem(
    EditItemModel editItemModel,
    List<AddExtraItemModel> extras,
      List<AddSizeItemModel> sizes,
      List<AddComponentItemModel> components,

    XFile? image,
      XFile? icon,
    List<XFile?> imagesExtra, {
    required bool isEdit,
  });

  Future<PaginatedModel<TableModel>> getTables({int? page});

  Future<void> addOrder(Map<String,dynamic> map);

  Future<List<ItemModel>> getSimilarItems(String type);
}
