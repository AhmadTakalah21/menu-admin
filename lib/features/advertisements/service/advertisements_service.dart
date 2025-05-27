import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/advertisements/model/add_advertisement_model/add_advertisement_model.dart';
import 'package:user_admin/features/advertisements/model/advertisement_model/advertisement_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';

part "advertisements_service_imp.dart";

abstract class AdvertisementsService {
  Future<List<AdvertisementModel>> getAdvertisements();

  Future<void> addAdvertisement(
    AddAdvertisementModel addAdvertisementModel, {
    required bool isEdit,
    required XFile? image,
  });
}
