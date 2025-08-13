import '../../../items/model/item_model/item_model.dart';

class CartItemModel {
  final ItemModel item;
  final int count;
  final int? selectedSizeId;
  final List<int> selectedToppingIds;
  final List<int> selectedComponentIds;

  CartItemModel({
    required this.item,
    required this.count,
    this.selectedSizeId,
    this.selectedToppingIds = const [],
    this.selectedComponentIds = const [],
  });

  CartItemModel copyWith({
    ItemModel? item,
    int? count,
    int? selectedSizeId,
    List<int>? selectedToppingIds,
    List<int>? selectedComponentIds,
  }) {
    return CartItemModel(
      item: item ?? this.item,
      count: count ?? this.count,
      selectedSizeId: selectedSizeId ?? this.selectedSizeId,
      selectedToppingIds: selectedToppingIds ?? this.selectedToppingIds,
      selectedComponentIds: selectedComponentIds ?? this.selectedComponentIds,
    );
  }
}
