part of 'restaurant_cubit.dart';

@immutable
sealed class RestaurantState {}

final class RestaurantInitial extends RestaurantState {}

final class RestaurantLoading extends RestaurantState {}

final class RestaurantSuccess extends RestaurantState {
  final RestaurantModel restaurant;

  RestaurantSuccess(this.restaurant);
}

final class RestaurantFail extends RestaurantState {
  final String error;

  RestaurantFail(this.error);
}