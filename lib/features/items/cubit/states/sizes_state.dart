part of '../items_cubit.dart';


@immutable
class SizesState extends GeneralItemsState{}

class SizesInitial extends SizesState {}

class SizesLoading extends SizesState {}

class SizesSuccess extends SizesState {
  final List<AddSizeItemModel> sizes;

  SizesSuccess(this.sizes);
}

class  SizesFail extends SizesState {
  final String error;

  SizesFail(this.error);
}

