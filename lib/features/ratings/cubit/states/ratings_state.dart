part of '../ratings_cubit.dart';

@immutable
class RatingsState extends GeneralRatingsState {}

final class RatingsInitial extends RatingsState {}

final class RatingsLoading extends RatingsState {}

final class RatingsSuccess extends RatingsState {
  final PaginatedModel<RateModel> paginatedModel;

  RatingsSuccess(this.paginatedModel);
}

final class RatingsEmpty extends RatingsState {
  final String message;

  RatingsEmpty(this.message);
}

final class RatingsFail extends RatingsState {
  final String error;

  RatingsFail(this.error);
}

