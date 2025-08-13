part of "items_service.dart";

@Injectable(as: ItemsService)
class ItemsServiceImp implements ItemsService {
  final dio = DioClient();

  @override
  Future<List<ItemModel>> getItems({
    int? categoryId,
    int? restaurantId,
    int perPage = 1000,
  }) async {
    try {
      // بناء معلمات الاستعلام بشكل نظيف ومرن
      final Map<String, dynamic> queryParameters = {
        if (categoryId != null) 'category_id': categoryId,
        if (restaurantId != null) 'restaurant_id': restaurantId,
        'per_page': perPage,
      };

      final response = await dio.get(
        "/admin_api/show_items",
        queries: queryParameters,
      );

      final data = response.data["data"] as List;
      return data
          .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<ItemModel> editItem(
      EditItemModel editItemModel,
      List<AddExtraItemModel> extras,
      List<AddSizeItemModel> sizes,
      List<AddComponentItemModel> components,
      XFile? image,
      XFile? icon,
      List<XFile?> imagesSizes,
      List<XFile?> imagesExtra, {
        required bool isEdit,
      }) async {
    try {
      final url = isEdit ? "update" : "add";

      // تحويل النموذج إلى Map (نسخة لتعديلها بدون التأثير على الأصل)
      final Map<String, dynamic> map = Map<String, dynamic>.from(editItemModel.toJson());

      // إزالة المفتاح nutrition لو موجود لأننا نعالجه بشكل منفصل
      map.remove('nutrition');

      // 1. معالجة معلومات التغذية
      _handleNutrition(map, editItemModel.nutrition);

      // 2. معالجة الإضافات (Toppings)
      _handleExtras(map, extras, imagesExtra);

      // 3. معالجة الأحجام (Sizes)
      await _handleSizes(map, sizes, imagesSizes);

      // 4. معالجة المكونات (Components)
      _handleComponents(map, components);

      // 5. معالجة الصور الرئيسية والثانوية
      await _handleImages(map, image, icon);

      // طباعة بيانات النموذج للتحقق (يمكن إزالة هذه الطباعة لاحقاً)
      print("Form data before sending: $map");

      final formData = FormData.fromMap(map);

      final response = await dio.post(
        "/admin_api/${url}_item",
        data: formData,
      );

      return ItemModel.fromJson(response.data["data"] as Map<String, dynamic>);
    } catch (e) {
      print("editItem error: $e");
      rethrow;
    }
  }

  void _handleNutrition(Map<String, dynamic> map, AddNutritionItemModel? nutrition) {
    if (nutrition != null) {
      map['is_nutrition'] = 1;
      map['nutrition[unit]'] = nutrition.unit ?? 'g';
      map['nutrition[kcal]'] = nutrition.kcal?.toString() ?? '0';
      map['nutrition[protein]'] = nutrition.protein?.toString() ?? '0';
      map['nutrition[fat]'] = nutrition.fat?.toString() ?? '0';
      map['nutrition[carbs]'] = nutrition.carbs?.toString() ?? '0';
      map['nutrition[amount]'] = nutrition.amount?.toString() ?? '0';
    } else {
      map['is_nutrition'] = 0;
      map.removeWhere((key, _) => key.startsWith('nutrition['));
    }
  }

  void _handleExtras(Map<String, dynamic> map, List<AddExtraItemModel> extras, List<XFile?> imagesExtra) {
    final validExtras = extras.where((e) =>
    (e.nameAr?.trim().isNotEmpty ?? false) &&
        (e.nameEn?.trim().isNotEmpty ?? false)).toList();

    map['is_topping'] = validExtras.isNotEmpty ? 1 : 0;

    if (validExtras.isEmpty) {
      map['toppings'] = [];
    } else {
      for (int index = 0; index < validExtras.length; index++) {
        final extra = validExtras[index];
        final extraImage = (imagesExtra.length > index) ? imagesExtra[index] : null;

        map["toppings[$index][name_ar]"] = extra.nameAr ?? '';
        map["toppings[$index][name_en]"] = extra.nameEn ?? '';
        map["toppings[$index][price]"] = extra.price ?? '';

        if (extraImage != null) {
          map["toppings[$index][icon]"] = MultipartFile.fromFileSync(
            extraImage.path,
            filename: extraImage.name,
          );
        } else {
          map["toppings[$index][icon]"] = extra.icon ?? '';
        }
      }
    }
  }

  Future<void> _handleSizes(Map<String, dynamic> map, List<AddSizeItemModel> sizes, List<XFile?> imagesSizes) async {
    final validSizes = sizes.where((s) =>
    (s.nameAr?.trim().isNotEmpty ?? false) &&
        (s.nameEn?.trim().isNotEmpty ?? false) &&
        (s.price?.toString().isNotEmpty ?? false)
    ).toList();

    if (validSizes.isNotEmpty) {
      map['is_size'] = 1;

      for (int index = 0; index < validSizes.length; index++) {
        final size = validSizes[index];
        final sizeImage = (imagesSizes.length > index) ? imagesSizes[index] : null;

        map["sizes[$index][name_ar]"] = size.nameAr ?? '';
        map["sizes[$index][name_en]"] = size.nameEn ?? '';
        map["sizes[$index][price]"] = size.price ?? '';
        map["sizes[$index][description_ar]"] = size.descriptionAr ?? '';
        map["sizes[$index][description_en]"] = size.descriptionEn ?? '';

        if (sizeImage != null) {
          map["sizes[$index][image]"] = await MultipartFile.fromFile(
            sizeImage.path,
            filename: sizeImage.name,
          );
        }
      }
    } else {
      map['is_size'] = 0;
      map['sizes'] = [];
    }
  }





  void _handleComponents(Map<String, dynamic> map, List<AddComponentItemModel> components) {
    final validComponents = components.where((c) =>
    (c.nameAr?.trim().isNotEmpty ?? false) &&
        (c.nameEn?.trim().isNotEmpty ?? false)).toList();

    map['is_component'] = validComponents.isNotEmpty ? 1 : 0;

    if (validComponents.isEmpty) {
      map['components'] = [];
    } else {
      for (int index = 0; index < validComponents.length; index++) {
        final component = validComponents[index];
        map["components[$index][name_ar]"] = component.nameAr ?? '';
        map["components[$index][name_en]"] = component.nameEn ?? '';
        map["components[$index][status]"] = component.isBasicComponent == IsBasicComponent.yes ? 1 : 0;
      }
    }
  }

  Future<void> _handleImages(Map<String, dynamic> map, XFile? image, XFile? icon) async {
    if (image != null) {
      map['image'] = await MultipartFile.fromFile(
        image.path,
        filename: image.name,
      );
    } else {
      map.remove('image');
    }

    if (icon != null) {
      map['icon'] = await MultipartFile.fromFile(
        icon.path,
        filename: icon.name,
      );
    } else {
      map.remove('icon');
    }
  }





  @override
  Future<PaginatedModel<TableModel>> getTables({int? page}) async {
    const perPageParam = "per_page=10";
    final pageParam = page != null ? "page=$page" : "";
    try {
      final response = await dio.get(
        "/admin_api/show_tables?$pageParam&$perPageParam",
      );
      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => TableModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addOrder(Map<String, dynamic> map) async {
    try {
      await dio.post(
        "/admin_api/add_order",
        data: FormData.fromMap(map),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ItemModel>> getSimilarItems(String type) async {
    final typeParam = "type=$type";
    try {
      final response = await dio.get(
        "/admin_api/show_similar_items?$typeParam",
      );
      final data = response.data["data"] as List;
      return List.generate(
        data.length,
        (index) => ItemModel.fromJson(
          data[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
