part of '../items_cubit.dart';

@immutable
 class ItemsState extends GeneralItemsState{}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsSuccess extends ItemsState {
  final List<ItemModel> items;

  ItemsSuccess(this.items);
}

class ItemsEmpty extends ItemsState {
  final String message;

  ItemsEmpty(this.message);
}

class ItemsFail extends ItemsState {
  final String error;

  ItemsFail(this.error);
}

