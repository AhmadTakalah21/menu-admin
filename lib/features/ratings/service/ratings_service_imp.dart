part of 'ratings_service.dart';

@Injectable(as: RatingsService)
class RatingsServiceImp implements RatingsService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<RateModel>> getRatings(
    int? page, {
    String? fromDate,
    String? toDate,
    String? gender,
    String? type,
    int? rate,
    int? fromAge,
    int? toAge,
  }) async {
    try {
      const restaurantIdParam = "restaurant_id=${AppConstants.restaurantId}";
      const perPageParam = "per_page=10";
      final pageParam = page != null ? "page=$page" : "";
      final genderParam = gender != null ? "gender=$gender" : "";
      final typeParam = type != null ? "type=$type" : "";
      final rateParam = rate != null ? "rate=$rate" : "";
      final fromAgeParam = fromAge != null ? "from_age=$fromAge" : "";
      final toAgeParam = toAge != null ? "to_age=$toAge" : "";
      final fromDateParam = fromDate != null ? "from_date=$fromDate" : "";
      final toDateParam = toDate != null ? "to_date=$toDate" : "";

      final response = await dio.get(
        "/admin_api/show_rates?$rateParam&$perPageParam&$restaurantIdParam&$genderParam&$fromAgeParam&$toAgeParam&$fromDateParam&$toDateParam&$pageParam&$typeParam",
      );
      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => RateModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
