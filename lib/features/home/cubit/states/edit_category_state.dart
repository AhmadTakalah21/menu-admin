part of '../home_cubit.dart';

@immutable
class EditCategoryState extends GeneralHomeState {}

class EditCategoryLoading extends EditCategoryState {}

class EditCategorySuccess extends EditCategoryState {
  final CategoryModel category;
  final String message;

  EditCategorySuccess(this.category, this.message);
}

class EditCategoryFail extends EditCategoryState {
  final String error;

  EditCategoryFail(this.error);
}
