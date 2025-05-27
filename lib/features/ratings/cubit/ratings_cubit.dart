import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/ratings/model/gender_enum.dart';
import 'package:user_admin/features/ratings/model/rate_enum.dart';
import 'package:user_admin/features/ratings/model/rate_model/rate_model.dart';
import 'package:user_admin/features/ratings/service/ratings_service.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'states/ratings_state.dart';

part 'states/general_ratings_state.dart';

@injectable
class RatingsCubit extends Cubit<GeneralRatingsState> {
  RatingsCubit(this.ratingsService) : super(GeneralRatingsInitial());
  final RatingsService ratingsService;

  String? fromDate;
  String? toDate;
  int? fromAge;
  int? toAge;
  GenderEnum? gender = GenderEnum.male;
  RateEnum? rate;
  String? type = "person";

  void resetParams() {
    fromDate = null;
    toDate = null;
    fromAge = null;
    toAge = null;
    gender = null;
    rate = null;
  }

  void setType(String? type) {
    this.type = type;
  }

  void setRate(RateEnum? rate) {
    this.rate = rate;
  }

  void setGender(GenderEnum? gender) {
    this.gender = gender;
  }

  void setFromAge(int? fromAge) {
    this.fromAge = fromAge;
  }

  void setToAge(int? toAge) {
    this.toAge = toAge;
  }

  void setFromDate(String? fromDate) {
    this.fromDate = fromDate;
  }

  void setToDate(String? toDate) {
    this.toDate = toDate;
  }

  Future<void> getRatings(int? page) async {
    emit(RatingsLoading());
    try {
      final response = await ratingsService.getRatings(
        page,
        fromDate: fromDate,
        toDate: toDate,
        fromAge: fromAge,
        toAge: toAge,
        gender: gender?.name,
        rate: rate?.id,
        type: type,
      );
      if (response.data.isEmpty) {
        emit(RatingsEmpty("no_ratings".tr()));
      } else {
        emit(RatingsSuccess(response));
      }
    } catch (e) {
      if (e is DioException) {
        emit(RatingsFail(e.message ?? e.toString()));
      } else {
        emit(RatingsFail(e.toString()));
      }
    }
  }
}
