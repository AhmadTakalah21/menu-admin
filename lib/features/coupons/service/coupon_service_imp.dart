part of "coupon_service.dart";

@Injectable(as: CouponService)
class CouponServiceImp implements CouponService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<CouponModel>> getCoupons({int? page}) async {
    final pageParam = page != null ? "page=$page" : "";
    const perPageParam = "per_page=10";
    try {
      final response =
          await dio.get("/admin_api/show_coupons?$perPageParam&$pageParam");

      final data = response.data as Map<String, dynamic>;
      return PaginatedModel.fromJson(
        data,
        (json) => CouponModel.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addCoupon(
    AddCouponModel addCouponModel, {
    required bool isEdit,
  }) async {
    final url = isEdit ? "update" : "add";
    try {
      await dio.post(
        "/admin_api/${url}_coupon",
        data: FormData.fromMap(
          addCouponModel.toJson(),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
