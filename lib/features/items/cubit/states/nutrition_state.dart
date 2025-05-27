part of '../items_cubit.dart';

@immutable
abstract class NutritionState extends GeneralItemsState {}

class NutritionInitial extends NutritionState {}

class NutritionAdded extends NutritionState {}

class NutritionRemoved extends NutritionState {}
