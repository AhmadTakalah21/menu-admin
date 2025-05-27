part of '../add_order_cubit.dart';

@immutable
class CartState extends GeneralAddOrderState {}

final class CartInitial extends CartState {}

final class CartSuccess extends CartState {
  final List<CartItemModel> cartItems;
  final int price;

  CartSuccess(this.cartItems, this.price);

}

final class CartEmpty extends CartState {
  final String message;

  CartEmpty(this.message);
}
