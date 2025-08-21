part of '../home_cubit.dart';

@immutable
class CategoriesState extends GeneralHomeState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesSuccess extends CategoriesState {
  final List<CategoryModel> categories;

  CategoriesSuccess(this.categories);
}

class CategoriesEmpty extends CategoriesState {
  final String message;

  CategoriesEmpty(this.message);
}


class CategoriesFail extends CategoriesState {
  final String error;

  CategoriesFail(this.error);
}
