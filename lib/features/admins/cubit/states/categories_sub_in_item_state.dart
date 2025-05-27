part of '../admins_cubit.dart';

@immutable
class CategoriesSubInItemState extends GeneralAdminsState {}

final class CategoriesSubInItemInitial extends CategoriesSubInItemState {}

final class CategoriesSubInItemLoading extends CategoriesSubInItemState {}

final class CategoriesSubInItemSuccess extends CategoriesSubInItemState {
  final List<CategoryModel> categories;

  CategoriesSubInItemSuccess(this.categories);
}

final class CategoriesSubInItemEmpty extends CategoriesSubInItemState {
  final String message;

  CategoriesSubInItemEmpty(this.message);
}

final class CategoriesSubInItemFail extends CategoriesSubInItemState {
  final String error;

  CategoriesSubInItemFail(this.error);
}
