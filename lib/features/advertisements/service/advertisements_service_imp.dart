part of "advertisements_service.dart";

@Injectable(as: AdvertisementsService)
class AdvertisementsServiceImp implements AdvertisementsService {
  final dio = DioClient();

  @override
  Future<List<AdvertisementModel>> getAdvertisements() async {
    try {
      final response = await dio.get(
        "/admin_api/show_advertisements",
      );
      final data = response.data["data"] as List;
      return List.generate(
        data.length,
        (index) => AdvertisementModel.fromJson(
          data[index] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addAdvertisement(
    AddAdvertisementModel addAdvertisementModel, {
    required bool isEdit,
    required XFile? image,
  }) async {
    try {
      final url = isEdit ? "update" : "add";
      final map = addAdvertisementModel.toJson();
      if (image != null) {
        map['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        );
      }

      await dio.post(
        "/admin_api/${url}_advertisement",
        data: FormData.fromMap(map),
      );
    } catch (e) {
      rethrow;
    }
  }
}
