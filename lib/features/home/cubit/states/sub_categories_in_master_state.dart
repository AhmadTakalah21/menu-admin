part of '../home_cubit.dart';

@immutable
class SubCategoriesInMasterState extends GeneralHomeState {}

class SubCategoriesInMasterLoading extends SubCategoriesInMasterState {}

class SubCategoriesInMasterSuccess extends SubCategoriesInMasterState {
  final List<CategoryModel> categories;

  SubCategoriesInMasterSuccess(this.categories);
}

class SubCategoriesInMasterEmpty extends SubCategoriesInMasterState {
  final String message;

  SubCategoriesInMasterEmpty(this.message);
}


class SubCategoriesInMasterFail extends SubCategoriesInMasterState {
  final String error;

  SubCategoriesInMasterFail(this.error);
}
