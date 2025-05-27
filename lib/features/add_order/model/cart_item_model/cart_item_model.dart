import 'package:user_admin/features/items/model/item_model/item_model.dart';

class CartItemModel {
  CartItemModel({
    required this.item,
    this.count = 0,
  });

  final ItemModel item;
  final int count;

  CartItemModel copyWith({
    ItemModel? item,
    int? count,
  }) {
    return CartItemModel(
      item: item ?? this.item,
      count: count ?? this.count,
    );
  }
}
