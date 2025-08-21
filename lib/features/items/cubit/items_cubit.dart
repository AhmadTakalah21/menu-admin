import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/items/model/add_component_item_model/add_component_item_model.dart';
import '../model/add_nutrition_item_model/add_nutrition_item_model.dart';
import '../model/add_size_item_model/add_size_item_model.dart';
import 'package:user_admin/features/items/model/add_extra_item_model/add_extra_item_model.dart';
import 'package:user_admin/features/items/model/edit_item_model/edit_item_model.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/features/items/service/items_service.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';

part 'states/items_state.dart';
part 'states/general_items_state.dart';
part 'states/edit_item_state.dart';
part 'states/extras_state.dart';
part 'states/sizes_state.dart';
part 'states/components_state.dart';
part 'states/nutrition_state.dart';
part 'states/tables_state.dart';
part 'states/add_order_state.dart';
part 'states/item_image_updated.dart';

@injectable
class ItemsCubit extends Cubit<GeneralItemsState> {
  ItemsCubit(this.itemsService) : super(GeneralItemsInitial());

  final ItemsService itemsService;

  List<ItemModel> localItems = [];
  EditItemModel editItemModel = const EditItemModel();
  XFile? selectedImage;
  XFile? selectedImage2;
  List<XFile?> imagesExtra = [];
  List<XFile?> imagesSizes = [];

  XFile? tempSelectedImage;
  XFile? tempSelectedImage2;
  List<XFile?> tempImagesExtra = [];
  List<XFile?> tempImagesSizes = [];

  final Map<int, XFile?> _itemImages = {};
  final Map<int, XFile?> _itemIcons = {};
  final Map<int, List<XFile?>> _itemExtraImages = {};
  final Map<int, XFile?> _itemExtraImagesMap = {};
  final Map<int, XFile?> _itemSizeImages = {};

  List<AddExtraItemModel> extras = [];
  List<AddSizeItemModel> sizes = [];
  List<AddComponentItemModel> components = [];

  int? itemId;
  int? tableId;
  String? count;
  bool _isFetching = false;

  void resetParams() {
    itemId = null;
    tableId = null;
    count = null;
  }

  void setNameEn(String? nameEn) {
    editItemModel = editItemModel.copyWith(nameEn: nameEn);
  }

  void setNameAr(String? nameAr) {
    editItemModel = editItemModel.copyWith(nameAr: nameAr);
  }

  void setDescriptionEn(String? descriptionEn) {
    editItemModel = editItemModel.copyWith(descriptionEn: descriptionEn);
  }

  void setDescriptionAr(String? descriptionAr) {
    editItemModel = editItemModel.copyWith(descriptionAr: descriptionAr);
  }

  void setPrice(String? price) {
    editItemModel = editItemModel.copyWith(price: price);
  }

  void setCategory(int? categoryId) {
    editItemModel = editItemModel.copyWith(categoryId: categoryId);
  }

  void setIsPanorama(int? isPanorama) {
    editItemModel = editItemModel.copyWith(isPanorama: isPanorama);
  }

  void setId(int id) {
    editItemModel = editItemModel.copyWith(id: id);
  }

  void setNameEnExtra(String? nameEn, int index) {
    extras[index] = extras[index].copyWith(nameEn: nameEn);
  }

  void setNameArExtra(String? nameAr, int index) {
    extras[index] = extras[index].copyWith(nameAr: nameAr);
  }

  void setPriceExtra(String? price, int index) {
    extras[index] = extras[index].copyWith(price: price);
  }

  void setItemId(int id) {
    itemId = id;
  }

  void setCount(String count) {
    this.count = count;
  }

  void setTableId(TableModel? table) {
    tableId = table?.id;
  }

  void resetModel(){
    editItemModel = const EditItemModel();
  }

  Future<void> setImage({int? itemId}) async {
    try {
      emit(ItemImageLoading());
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        tempSelectedImage = image; // نعرض الصورة فقط، لا نحفظها
        emit(ItemImageUpdated(
          selectedImage: tempSelectedImage,
          selectedImage2: tempSelectedImage2,
        ));
      }
    } catch (e) {
      emit(ItemImageError('Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> setImage2({int? itemId}) async {
    try {
      emit(ItemImageLoading());
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        tempSelectedImage2 = image; // فقط للمعاينة
        emit(ItemImageUpdated(
          selectedImage: tempSelectedImage,
          selectedImage2: tempSelectedImage2,
        ));
      }
    } catch (e) {
      emit(ItemImageError('Failed to pick image 2: ${e.toString()}'));
    }
  }

  Future<void> setImageExtra(int index, {int? itemId}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final image = XFile(pickedFile.path);
      _itemExtraImagesMap[index] = image;
      emit(ExtrasSuccess(List.from(extras)));
    }
  }

  Future<void> setImageSize(int index, {int? itemId}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final image = XFile(pickedFile.path);
      _itemSizeImages[index] = image;

      if (index >= 0 && index < sizes.length) {
        sizes[index] = sizes[index].copyWith(image: image.path);
      }

      emit(SizesSuccess(List.from(sizes)));
    }
  }

  void applyTempImages() {
    selectedImage = tempSelectedImage;
    selectedImage2 = tempSelectedImage2;
    imagesExtra = List.from(tempImagesExtra);
    imagesSizes = List.from(tempImagesSizes);
  }

  void clearTempImages() {
    tempSelectedImage = null;
    tempSelectedImage2 = null;
    tempImagesExtra.clear();
    tempImagesSizes.clear();
  }

  List<XFile?>? getItemExtraImages(int itemId) {
    return _itemExtraImages[itemId];
  }

  XFile? getExtraImage(int index) => _itemExtraImagesMap[index];

  XFile? getItemImage(int itemId) => _itemImages[itemId];
  XFile? getItemIcon(int itemId) => _itemIcons[itemId];

  void addExtra(ItemModel? item) {
    AddExtraItemModel addExtraItemModel = const AddExtraItemModel();
    extras.add(addExtraItemModel);
    imagesExtra.add(null);
    getExtras(item, isRemove: false);
  }

  void removeExtra(ItemModel? item, int index) {
    extras.removeAt(index);
    imagesExtra.removeAt(index);
    getExtras(item, isRemove: true);
  }

  void clearExtras() {
    extras.clear();
    imagesExtra.clear();
    getExtras(null, isRemove: true);
  }

  void getExtras(ItemModel? item, {required bool isRemove}) {
    emit(ExtrasLoading());

    if (!isRemove && item != null) {
      final itemId = item.id;

      for (var i in item.itemTypes) {
        AddExtraItemModel addExtraItemModel = AddExtraItemModel(
          nameAr: i.nameAr,
          nameEn: i.nameEn,
          price: i.price,
          itemId: itemId,
          icon: i.image,
        );

        int index = extras.indexWhere(
              (element) => element.nameAr == addExtraItemModel.nameAr &&
              element.itemId == itemId,
        );

        if (index == -1) {
          extras.add(addExtraItemModel);
          imagesExtra.add(null);
        }
      }
    }

    if (isRemove) {
      extras.clear();
      imagesExtra.clear();
    }

    emit(ExtrasSuccess(List.from(extras)));
  }

  void setNameEnSize(String? nameEn, int index) {
    sizes[index] = sizes[index].copyWith(nameEn: nameEn);
  }

  void setNameArSize(String? nameAr, int index) {
    sizes[index] = sizes[index].copyWith(nameAr: nameAr);
  }

  void setPriceSize(String? price, int index) {
    sizes[index] = sizes[index].copyWith(price: price);
  }

  void setDescriptionArSize(String description, int index) {
    if (index >= 0 && index < sizes.length) {
      sizes[index] = sizes[index].copyWith(descriptionAr: description);
      emit(SizesSuccess(List.from(sizes)));
    }
  }

  void setDescriptionEnSize(String description, int index) {
    if (index >= 0 && index < sizes.length) {
      sizes[index] = sizes[index].copyWith(descriptionEn: description);
      emit(SizesSuccess(List.from(sizes)));
    }
  }

  void addSize(ItemModel? item) {
    AddSizeItemModel addSizeItemModel = const AddSizeItemModel();
    sizes.add(addSizeItemModel);
    getSizes(item, isRemove: false);
  }

  XFile? getSizeImage(int index) => _itemSizeImages[index];

  void removeSize(ItemModel? item, int index) {
    sizes.removeAt(index);
    getSizes(item, isRemove: true);
  }

  void clearSizes() {
    sizes.clear();
    getSizes(null, isRemove: true);
  }

  void getSizes(ItemModel? item, {required bool isRemove}) {
    if (isRemove) {
      sizes.clear();
    }

    if (!isRemove && item != null) {
      for (var size in item.sizesTypes) {
        AddSizeItemModel addSizeItemModel = AddSizeItemModel(
          nameAr: size.nameAr,
          nameEn: size.nameEn,
          price: size.price,
          itemId: item.id,
          descriptionAr: size.descriptionAr,
          descriptionEn: size.descriptionEn,
          image: size.image,
        );

        int index = sizes.indexWhere(
              (element) =>
          element.nameAr == addSizeItemModel.nameAr &&
              element.itemId == item.id,
        );

        if (index == -1) {
          sizes.add(addSizeItemModel);
        }
      }
    }

    emit(SizesSuccess(List.from(sizes)));
  }

  void setNameEnComponent(String? nameEn, int index) {
    components[index] = components[index].copyWith(nameEn: nameEn);
  }

  void setNameArComponent(String? nameAr, int index) {
    components[index] = components[index].copyWith(nameAr: nameAr);
  }

  void setIsBasicComponent(IsBasicComponent isBasic, int index) {
    if (components.isNotEmpty && index >= 0 && index < components.length) {
      final updatedComponents = List<AddComponentItemModel>.from(components);
      updatedComponents[index] = updatedComponents[index].copyWith(
        isBasicComponent: isBasic,
      );
      components = updatedComponents;
      emit(ComponentsSuccess(updatedComponents));
    }
  }

  void addComponent(ItemModel? item) {
    AddComponentItemModel addComponentItemModel = const AddComponentItemModel(
      isBasicComponent: IsBasicComponent.no,
    );
    components.add(addComponentItemModel);
    getComponents(item, isRemove: false);
  }

  void removeComponent(ItemModel? item, int index) {
    components.removeAt(index);
    getComponents(item, isRemove: true);
  }

  void clearComponents() {
    components.clear();
    getComponents(null, isRemove: true);
  }

  void getComponents(ItemModel? item, {required bool isRemove}) {
    if (!isRemove && item != null) {
      for (var component in item.componentsTypes) {
        AddComponentItemModel addComponentItemModel = AddComponentItemModel(
          nameAr: component.nameAr,
          nameEn: component.nameEn,
          itemId: item.id,
          isBasicComponent:
          component.isSelectable ? IsBasicComponent.yes : IsBasicComponent.no,
        );
        int index = components.indexWhere(
              (element) =>
          element.nameAr == addComponentItemModel.nameAr &&
              element.itemId == item.id,
        );
        if (index == -1) {
          components.add(addComponentItemModel);
        }
      }
    }
    emit(ComponentsSuccess(List.from(components)));
  }

  void addNutrition() {
    editItemModel = editItemModel.copyWith(nutrition: AddNutritionItemModel.empty());
    emit(NutritionAdded());
  }

  void removeNutrition() {
    editItemModel = editItemModel.copyWith(nutrition: null);
    emit(NutritionRemoved());
  }

  void setNutrition({
    double? amount,
    String? unit,
    double? kcal,
    double? protein,
    double? fat,
    double? carbs,
  }) {
    final currentNutrition = editItemModel.nutrition ?? AddNutritionItemModel.empty();

    editItemModel = editItemModel.copyWith(
      nutrition: currentNutrition.copyWith(
        amount: amount ?? currentNutrition.amount,
        unit: unit ?? currentNutrition.unit,
        kcal: kcal ?? currentNutrition.kcal,
        protein: protein ?? currentNutrition.protein,
        fat: fat ?? currentNutrition.fat,
        carbs: carbs ?? currentNutrition.carbs,
      ),
    );
  }

  void setWeight(double? weight) {
    setNutrition(amount: weight);
  }

  void setCalories(double? calories) {
    setNutrition(kcal: calories);
  }

  void setProtein(double? protein) {
    setNutrition(protein: protein);
  }

  void setFat(double? fat) {
    setNutrition(fat: fat);
  }

  void setCarbs(double? carbs) {
    setNutrition(carbs: carbs);
  }

  Future<void> getItems({
    int? restaurantId,
    int? categoryId,
    required bool isRefresh,
  }) async {
    if (_isFetching) {
      return;
    }
    _isFetching = true;

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("items$categoryId");

    if (data != null && !isRefresh) {
      try {
        List<ItemModel> items = List.generate(
          data.length,
              (index) => ItemModel.fromString(data[index]),
        );
        emit(ItemsSuccess(items));
        localItems = items;
        _isFetching = false;
        return;
      } catch (e) {
        // في حالة خطأ في parsing البيانات المحفوظة، نستدعي API
        await _fetchItemsFromApi(restaurantId, categoryId, prefs);
        _isFetching = false;
      }
    } else {
      await _fetchItemsFromApi(restaurantId, categoryId, prefs);
      _isFetching = false;
    }
  }

  Future<void> _fetchItemsFromApi(
      int? restaurantId, int? categoryId, SharedPreferences prefs) async {
    emit(ItemsLoading());
    try {
      final response = await itemsService.getItems(
        categoryId: categoryId,
        restaurantId: restaurantId,
      );
      localItems = response;

      List<String> itemsString =
      response.map((item) => item.toString()).toList();
      await prefs.setStringList("items$categoryId", itemsString);
      emit(ItemsSuccess(response));
    } catch (e) {
      emit(ItemsFail(e.toString()));

      // fallback للـ cache إن أمكن
      final data = prefs.getStringList("items$categoryId");
      if (data != null && data.isNotEmpty) {
        try {
          List<ItemModel> items = data
              .map((itemString) => ItemModel.fromString(itemString))
              .toList();
          localItems = items;
          emit(ItemsSuccess(items));
        } catch (parseError) {
          emit(ItemsFail("Failed to load cached data: ${parseError.toString()}"));
        }
      }
    }
  }

  // ---------------------------
  // 🔎 البحث الموحّد بالاسم
  // ---------------------------

  /// بحث محلي بالاسم (AR/EN) داخل آخر قائمة تم تحميلها في localItems
  void searchByName(String q) {
    final source = localItems;
    if (source.isEmpty) {
      emit(ItemsEmpty("no_items".tr()));
      return;
    }

    final query = q.trim().toLowerCase();
    if (query.isEmpty) {
      emit(ItemsSuccess(source));
      return;
    }

    bool _contains(String? s) =>
        (s ?? '').toLowerCase().contains(query);

    final filtered = source.where((item) {
      return _contains(item.name) ||
          _contains(item.nameAr) ||
          _contains(item.nameEn) ||
          _contains(item.descriptionAr) ||
          _contains(item.descriptionEn);
    }).toList();

    if (filtered.isEmpty) {
      emit(ItemsEmpty("no_items".tr()));
    } else {
      emit(ItemsSuccess(filtered));
    }
  }

  /// لإرجاع القائمة الأصلية بعد إلغاء البحث
  void clearSearch() {
    emit(ItemsSuccess(localItems));
  }

  /// (للتوافق الرجعي) كانت لديك دالة بهذا الاسم — الآن تستدعي الموحّدة
  void searchForItem(String input) {
    searchByName(input);
  }

  Future<void> editItem({required bool isEdit, int? itemId}) async {
    if (isEdit && itemId != null) {
      setId(itemId);

      selectedImage = tempSelectedImage ?? selectedImage;
      selectedImage2 = tempSelectedImage2 ?? selectedImage2;
    }

    applyTempImages();
    emit(EditItemLoading());

    try {
      final editedItem = await itemsService.editItem(
        editItemModel,
        extras,
        sizes,
        components,
        selectedImage,
        selectedImage2,
        imagesExtra,
        imagesSizes,
        isEdit: isEdit,
      );
      final successMessage =
      isEdit ? "edit_item_success".tr() : "add_item_success".tr();
      emit(EditItemSuccess(editedItem, successMessage));
    } catch (e) {
      emit(EditItemFail(e.toString()));
    }
  }

  Future<void> getTables({int? page}) async {
    emit(TablesLoading());
    try {
      final tables = await itemsService.getTables(page: page);
      if (tables.data.isEmpty) {
        emit(TablesEmpty("no_tables".tr()));
      } else {
        emit(TablesSuccess(tables));
      }
    } catch (e) {
      emit(TablesFail(e.toString()));
    }
  }

  Future<void> addOrder() async {
    final count = this.count;
    if (tableId == null) {
      emit(AddOrderFail("table_num_empty".tr()));
      return;
    }
    if (count == null || count.isEmpty) {
      emit(AddOrderFail("quantity_empty".tr()));
      return;
    }
    final Map<String, dynamic> map = {};
    map.addAll({"data[0][item_id]": itemId, "data[0][count]": count, "table_id": tableId});
    emit(AddOrderLoading());
    try {
      await itemsService.addOrder(map);
      emit(AddOrderSuccess("order_added".tr()));
    } catch (e) {
      emit(AddOrderFail(e.toString()));
    }
  }

  Future<void> getSimilarItems(String type) async {
    emit(ItemsLoading());
    try {
      final response = await itemsService.getSimilarItems(type);
      if (response.isEmpty) {
        emit(ItemsEmpty("no_items".tr()));
      } else {
        emit(ItemsSuccess(response));
      }
    } catch (e) {
      emit(ItemsFail(e.toString()));
    }
  }
}
