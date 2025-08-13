import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/ratings/model/rate_model/rate_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/utils/constants.dart';

part 'ratings_service_imp.dart';

abstract class RatingsService {
  Future<PaginatedModel<RateModel>> getRatings(
    int? page, {
    String? fromDate,
    String? toDate,
    String? gender,
    String? type,
    int? rate,
    int? fromAge,
    int? toAge,
  });

}