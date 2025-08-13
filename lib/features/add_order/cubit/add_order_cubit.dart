
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/add_order/model/cart_item_model/cart_item_model.dart';
import 'package:user_admin/features/add_order/service/add_order_service.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';

part 'states/add_order_state.dart';
part 'states/categories_subs_items_state.dart';
part 'states/general_add_order_state.dart';
part 'states/cart_state.dart';

@injectable
class AddOrderCubit extends Cubit<GeneralAddOrderState> {
  AddOrderCubit(this.addOrderService) : super(GeneralAddOrderInitial());
  final AddOrderService addOrderService;

  List<CartItemModel> cartItems = [];
  Map<String, dynamic> mapOrder = {};

  int total = 0;
  int totalPrice = 0;
  int? tableId;

  void resetParams() {
    cartItems.clear();
    mapOrder = {};
    tableId = null;
    total = 0;
    totalPrice = 0;
    emit(AddToCartSuccess());
  }

  void setTableId(TableModel? table) {
    tableId = table?.id;
  }

  void addToCart(
      ItemModel item, {
        int? selectedSizeId,
        List<int>? selectedToppingIds,
        List<int>? selectedComponentIds,
      }) {
    if (item.sizesTypes.isNotEmpty && selectedSizeId == null) {
      emit(AddOrderFail("size_required".tr()));
      return;
    }

    final newCartItem = CartItemModel(
      item: item,
      count: 1,
      selectedSizeId: selectedSizeId,
      selectedToppingIds: selectedToppingIds ?? [],
      selectedComponentIds: selectedComponentIds ?? [],
    );

    final newKey = _generateCartItemKey(newCartItem);

    final existingIndex = cartItems.indexWhere(
          (element) => _generateCartItemKey(element) == newKey,
    );

    final fullPrice = calculateCartItemPrice(newCartItem);

    if (existingIndex != -1) {
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        count: cartItems[existingIndex].count + 1,
      );
    } else {
      cartItems.add(newCartItem);
    }

    total += fullPrice;
    totalPrice += fullPrice;

    emit(AddToCartSuccess());
    emit(CartSuccess(cartItems, total));
  }



  bool _isSameCartItem(CartItemModel a, CartItemModel b) {
    return a.item.id == b.item.id &&
        a.selectedSizeId == b.selectedSizeId &&
        _listEquals(a.selectedToppingIds, b.selectedToppingIds) &&
        _listEquals(a.selectedComponentIds, b.selectedComponentIds);
  }

  String _generateCartItemKey(CartItemModel item) {
    final toppings = [...item.selectedToppingIds]..sort();
    final components = [...item.selectedComponentIds]..sort();
    return "${item.item.id}-${item.selectedSizeId}-${toppings.join(",")}-${components.join(",")}";
  }


  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    final aSorted = [...a]..sort();
    final bSorted = [...b]..sort();
    for (int i = 0; i < aSorted.length; i++) {
      if (aSorted[i] != bSorted[i]) return false;
    }
    return true;
  }

  int _getSizePrice(ItemModel item, int? sizeId) {
    if (sizeId == null || item.sizesTypes.isEmpty) return 0;
    final selectedSize = item.sizesTypes.firstWhere(
          (s) => s.id == sizeId,
      orElse: () => item.sizesTypes.first,
    );
    return int.tryParse(selectedSize.price?.replaceAll(',', '') ?? '') ?? 0;
  }

  int _getToppingsPrice(ItemModel item, List<int>? toppingIds) {
    if (toppingIds == null || toppingIds.isEmpty) return 0;
    int sum = 0;
    for (var id in toppingIds) {
      try {
        final topping = item.itemTypes.firstWhere((t) => t.id == id);
        sum += int.tryParse(topping.price?.replaceAll(',', '') ?? '') ?? 0;
      } catch (_) {}
    }
    return sum;
  }

  int calculateCartItemPrice(CartItemModel cartItem) {
    int basePrice = 0;

    if (cartItem.item.sizesTypes.isNotEmpty) {
      if (cartItem.selectedSizeId != null) {
        basePrice = _getSizePrice(cartItem.item, cartItem.selectedSizeId);
      } else {
        basePrice = int.tryParse(cartItem.item.sizesTypes.first.price?.replaceAll(',', '') ?? '') ?? 0;
      }
    } else {
      basePrice = int.tryParse(cartItem.item.price.replaceAll(',', '')) ?? 0;
    }

    final toppings = _getToppingsPrice(cartItem.item, cartItem.selectedToppingIds);
    return basePrice + toppings;
  }


  void addItem(CartItemModel item) {
    final index = cartItems.indexWhere((e) => _isSameCartItem(e, item));
    if (index == -1) return;
    cartItems[index] = item.copyWith(count: item.count + 1);
    final price = calculateCartItemPrice(item);
    total += price;
    totalPrice += price;

    emit(AddToCartSuccess());
    emit(CartSuccess(cartItems, total));
  }


  void removeItem(CartItemModel item) {
    final index = cartItems.indexWhere((e) => _isSameCartItem(e, item));
    if (index == -1) return;
    final price = calculateCartItemPrice(item);
    if (cartItems[index].count == 1) {
      cartItems.removeAt(index);
    } else {
      cartItems[index] = item.copyWith(count: item.count - 1);
    }
    total -= price;
    totalPrice -= price;

    emit(AddToCartSuccess());
    if (cartItems.isEmpty) {
      emit(CartEmpty("no_items".tr()));
    } else {
      emit(CartSuccess(cartItems, total));
    }
  }



  Future<void> getCategories(int restaurantId) async {
    emit(CategoriesSubsItemsLoading());
    try {
      final categories = await addOrderService.getCategoriesSubsItems(restaurantId);
      if (categories.isEmpty) {
        emit(CategoriesSubsItemsEmpty("no_categories".tr()));
      } else {
        emit(CategoriesSubsItemsSuccess(categories));
      }
    } catch (e) {
      emit(CategoriesSubsItemsFail(e.toString()));
    }
  }

  void getCartItems() {
    if (cartItems.isEmpty) {
      emit(CartEmpty("no_items".tr()));
    } else {
      emit(CartSuccess(cartItems, total));
    }
  }

  Future<void> postOrder() async {
    if (tableId == null) {
      emit(AddOrderFail("table_required".tr()));
      return;
    }

    final List<Map<String, dynamic>> orderData = [];

    for (final cartItem in cartItems) {
      final item = cartItem.item;

      orderData.add({
        "item_id": item.id,
        "count": cartItem.count,
        if (cartItem.selectedSizeId != null) "size_id": cartItem.selectedSizeId,
        "toppings": cartItem.selectedToppingIds.map((id) => {"topping_id": id}).toList(),
        "components": cartItem.selectedComponentIds.map((id) => {"component_id": id}).toList(),
      });
    }

    final requestBody = {
      "table_id": tableId,
      "data": orderData,
    };

    emit(AddOrderLoading());

    try {
      await addOrderService.addOrder(requestBody);
      emit(AddOrderSuccess());
      resetParams();
      emit(CartEmpty("no_items".tr()));
    } catch (e) {
      emit(AddOrderFail(e.toString()));
    }
  }




}
