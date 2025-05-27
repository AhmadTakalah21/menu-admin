part of '../home_cubit.dart';

@immutable
class SubCategoriesState extends GeneralHomeState {}

class SubCategoriesLoading extends SubCategoriesState {}

class SubCategoriesSuccess extends SubCategoriesState {
  final List<CategoryModel> categories;

  SubCategoriesSuccess(this.categories);
}

class SubCategoriesFail extends SubCategoriesState {
  final String error;

  SubCategoriesFail(this.error);
}
