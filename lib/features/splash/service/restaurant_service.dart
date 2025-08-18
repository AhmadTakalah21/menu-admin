import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/constants.dart';

part 'restaurant_service_imp.dart';

abstract class RestaurantService {
  Future<RestaurantModel> getRestaurantInfo();
}
