part of '../restaurant_cubit.dart';

@immutable
class UpdateRestaurantState extends GeneralRestaurantState {}

final class UpdateRestaurantInitial extends UpdateRestaurantState {}

final class UpdateRestaurantLoading extends UpdateRestaurantState {}

final class UpdateRestaurantSuccess extends UpdateRestaurantState {
  final String message;

  UpdateRestaurantSuccess(this.message);
}

final class UpdateRestaurantFail extends UpdateRestaurantState {
  final String error;

  UpdateRestaurantFail(this.error);
}
