import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/restaurant/model/update_restaurant_model/update_restaurant_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';

part 'restaurant_service_imp.dart';

abstract class RestaurantService {
  Future<RestaurantModel> getRestaurant();

  Future<void> updateRestaurant(
    UpdateRestaurantModel updateRestaurantModel, {
    XFile? logo,
    XFile? cover,
  });
}
