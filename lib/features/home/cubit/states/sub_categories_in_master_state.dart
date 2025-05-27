part of '../home_cubit.dart';

@immutable
class SubCategoriesInMasterState extends GeneralHomeState {}

class SubCategoriesInMasterLoading extends SubCategoriesInMasterState {}

class SubCategoriesInMasterSuccess extends SubCategoriesInMasterState {
  final List<CategoryModel> categories;

  SubCategoriesInMasterSuccess(this.categories);
}

class SubCategoriesInMasterFail extends SubCategoriesInMasterState {
  final String error;

  SubCategoriesInMasterFail(this.error);
}
