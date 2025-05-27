part of '../add_order_cubit.dart';

@immutable
class CategoriesSubsItemsState extends GeneralAddOrderState {}

final class CategoriesSubsItemsInitial extends CategoriesSubsItemsState {}

final class CategoriesSubsItemsLoading extends CategoriesSubsItemsState {}

final class CategoriesSubsItemsSuccess extends CategoriesSubsItemsState {
  final List<CategoryModel> categories;

  CategoriesSubsItemsSuccess(this.categories);
}

final class CategoriesSubsItemsEmpty extends CategoriesSubsItemsState {
  final String message;

  CategoriesSubsItemsEmpty(this.message);
}

final class CategoriesSubsItemsFail extends CategoriesSubsItemsState {
  final String error;

  CategoriesSubsItemsFail(this.error);
}
