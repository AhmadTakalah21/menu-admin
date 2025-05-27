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

  void addToCart(ItemModel item) {
    int existingIndex = cartItems.indexWhere(
      (cartItem) => cartItem.item.id == item.id,
    );

    if (existingIndex == -1) {
      cartItems.add(CartItemModel(item: item, count: 1));
    } else {
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        item: item,
        count: cartItems[existingIndex].count + 1,
      );
    }
    final price = int.parse(item.price.replaceAll(RegExp(r','), ''));
    total += price;
    totalPrice += price;

    emit(AddToCartSuccess());
  }

  void addItem(ItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) => cartItem.item.id == item.id,
    );
    cartItems[index] = cartItems[index].copyWith(
      item: item,
      count: cartItems[index].count + 1,
    );
    final price = int.parse(item.price.replaceAll(RegExp(r','), ''));
    total += price;
    totalPrice += price;

    emit(AddToCartSuccess());
  }

  void removeItem(ItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) => cartItem.item.id == item.id,
    );
    if (cartItems[index].count == 1) {
      cartItems.remove(cartItems[index]);
      getCartItems();
    } else {
      cartItems[index] = cartItems[index].copyWith(
        item: item,
        count: cartItems[index].count - 1,
      );
    }
    final price = int.parse(item.price.replaceAll(RegExp(r','), ''));
    total -= price;
    totalPrice -= price;

    emit(AddToCartSuccess());
  }

  Future<void> getCategories() async {
    emit(CategoriesSubsItemsLoading());
    try {
      final categories = await addOrderService.getCategoriesSubsItems();
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
    for (int index = 0; index < cartItems.length; index++) {
      mapOrder.addAll({
        "data[$index][item_id]": cartItems[index].item.id,
        "data[$index][count]": cartItems[index].count
      });
    }
    mapOrder.addAll({"table_id": tableId});

    emit(AddOrderLoading());
    try {
      await addOrderService.addOrder(mapOrder);
      emit(AddOrderSuccess());
      resetParams();
      emit(CartEmpty("no_items".tr()));
    } catch (e) {
      emit(AddOrderFail(e.toString()));
    }
  }
}
