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

  final Map<int, XFile?> _itemImages = {}; // الصور الرئيسية
  final Map<int, XFile?> _itemIcons = {};  // الأيقونات
  final Map<int, List<XFile?>> _itemExtraImages = {}; // صور الإضافات

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

  Future<void> setImage({int? itemId}) async {
    try {
      emit(ItemImageLoading());
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (itemId != null) {
          _itemImages[itemId] = image;
        } else {
          selectedImage = image; // للعناصر الجديدة
        }
        emit(ItemImageUpdated(
          selectedImage: itemId != null ? _itemImages[itemId] : selectedImage,
          selectedImage2: itemId != null ? _itemIcons[itemId] : selectedImage2,
        ));
      }
    } catch (e) {
      emit(ItemImageError('Failed to pick image: ${e.toString()}'));
    }
  }

// نفس الشيء لـ setImage2
  Future<void> setImage2({int? itemId}) async {
    try {
      emit(ItemImageLoading());
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (itemId != null) {
          _itemIcons[itemId] = image;
        } else {
          selectedImage2 = image; // للعناصر الجديدة
        }
        emit(ItemImageUpdated(
          selectedImage: itemId != null ? _itemImages[itemId] : selectedImage,
          selectedImage2: itemId != null ? _itemIcons[itemId] : selectedImage2,
        ));
      }
    } catch (e) {
      emit(ItemImageError('Failed to pick image 2: ${e.toString()}'));
    }
  }

  List<XFile?>? getItemExtraImages(int itemId) {
    return _itemExtraImages[itemId];
  }
  Future<void> setImageExtra(int index, {int? itemId}) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (itemId != null) {
        if (!_itemExtraImages.containsKey(itemId)) {
          _itemExtraImages[itemId] = [];
        }
        if (_itemExtraImages[itemId]!.length <= index) {
          _itemExtraImages[itemId]!.add(image);
        } else {
          _itemExtraImages[itemId]![index] = image;
        }
      } else {
        if (imagesExtra.length <= index) {
          imagesExtra.add(image);
        } else {
          imagesExtra[index] = image;
        }
      }
    }
  }

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
    if (!isRemove) {
      if (item != null) {
        for (var i in item.itemTypes) {
          AddExtraItemModel addExtraItemModel = AddExtraItemModel(
            nameAr: i.nameAr,
            nameEn: i.nameEn,
            price: i.price,
          );
          int index = extras.indexWhere(
            (element) => element.nameAr == addExtraItemModel.nameAr,
          );
          if (index == -1) {
            extras.add(addExtraItemModel);
            imagesExtra.add(null);
          }
        }
      }
    }
    emit(ExtrasSuccess(extras));
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

  void addSize(ItemModel? item) {
    AddSizeItemModel addSizeItemModel = const AddSizeItemModel();
    sizes.add(addSizeItemModel);
    getSizes(item, isRemove: false);
  }

  void removeSize(ItemModel? item, int index) {
    sizes.removeAt(index);
    getSizes(item, isRemove: true);
  }

  void clearSizes() {
    sizes.clear();
    getSizes(null, isRemove: true);
  }

  void getSizes(ItemModel? item, {required bool isRemove}) {
    if (!isRemove && item != null) {
      for (var size in item.sizesTypes) {
        AddSizeItemModel addSizeItemModel = AddSizeItemModel(
          nameAr: size.nameAr,
          nameEn: size.nameEn,
          price: size.price,
        );
        int index = sizes.indexWhere(
              (element) => element.nameAr == addSizeItemModel.nameAr,
        );
        if (index == -1) {
          sizes.add(addSizeItemModel);
        }
      }
    }
    emit(SizesSuccess(sizes));
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
      isBasicComponent: IsBasicComponent.no, // قيمة افتراضية
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
          isBasicComponent: component.isBasicComponent == 1
              ? IsBasicComponent.yes
              : IsBasicComponent.no,
        );
        int index = components.indexWhere(
              (element) => element.nameAr == addComponentItemModel.nameAr,
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
      print("Fetch already in progress, skipping.");
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
      } catch (e, stackTrace) {
        print("Error parsing cached items: $e");
        print(stackTrace);
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
      localItems = response; // تأكد من تحديث localItems هنا

      List<String> itemsString = response.map((item) => item.toString()).toList();
      await prefs.setStringList("items$categoryId", itemsString);
      emit(ItemsSuccess(response));
    } catch (e, stackTrace) {
      print("Error fetching items from API: $e");
      print(stackTrace);
      emit(ItemsFail(e.toString()));

      // حاول استخدام البيانات المحفوظة فقط إذا كانت موجودة وصالحة
      final data = prefs.getStringList("items$categoryId");
      if (data != null && data.isNotEmpty) {
        try {
          List<ItemModel> items = data.map((itemString) => ItemModel.fromString(itemString)).toList();
          localItems = items; // تأكد من تحديث localItems هنا أيضًا
          emit(ItemsSuccess(items));
        } catch (parseError, parseStack) {
          print("Failed to load cached data: $parseError");
          print(parseStack);
          emit(ItemsFail("Failed to load cached data: ${parseError.toString()}"));
        }
      }
    }
  }

  void searchForItem(String input) {
    final searchedItems = localItems
        .where(
          (item) =>
              item.nameEn.toLowerCase().contains(input.toLowerCase()) ||
              item.nameAr.toLowerCase().contains(input.toLowerCase()),
        )
        .toList();
    emit(ItemsSuccess(searchedItems));
  }

  Future<void> editItem({required bool isEdit, int? itemId}) async {
    if (isEdit && itemId != null) {
      setId(itemId);
      // استرجاع الصور الخاصة بهذا العنصر قبل الحفظ
      selectedImage = _itemImages[itemId];
      selectedImage2 = _itemIcons[itemId];
      if (_itemExtraImages.containsKey(itemId)) {
        imagesExtra = _itemExtraImages[itemId]!;
      }
    }

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
    map.addAll({
      "data[0][item_id]": itemId,
      "data[0][count]": count,
      "table_id": tableId
    });
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
