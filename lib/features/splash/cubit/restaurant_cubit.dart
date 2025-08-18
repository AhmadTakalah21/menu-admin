import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/splash/service/restaurant_service.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/constants.dart';

part 'restaurant_state.dart';

@injectable
class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit(this.restaurantService) : super(RestaurantInitial());

  final RestaurantService restaurantService;

  Future<void> getRestaurantInfo({required bool isRefresh}) async {
    final prefs = await SharedPreferences.getInstance();
    final localData = prefs.getString(AppConstants.restaurantId);

    if (localData != null && !isRefresh) {
      try {
        final restaurant = _parseRestaurantData(localData);
        if (isClosed) return;
        emit(RestaurantSuccess(restaurant));
        return;
      } catch (e) {
        if (isClosed) return;
        debugPrint('Error loading local restaurant data: $e');
      }
    }
    if (isClosed) return;
    emit(RestaurantLoading());
    try {
      if (isClosed) return;
      final response = await restaurantService.getRestaurantInfo();

      final safeJson = _ensureSafeJson(response.toJson());
      await prefs.setString(AppConstants.restaurantId, jsonEncode(safeJson));
      await prefs.setString(AppConstants.restaurantLogo, response.logoHomePage!);
      emit(RestaurantSuccess(response));
    } catch (e) {
      debugPrint('Error fetching restaurant info: $e');

      if (localData != null) {
        try {
          if (isClosed) return;
          final restaurant = _parseRestaurantData(localData);
          emit(RestaurantSuccess(restaurant));
          return;
        } catch (_) {
          if (isClosed) return;
          debugPrint('Error falling back to local data');
        }
      }
      if (isClosed) return;
      emit(RestaurantFail(e.toString()));
    }
  }

  RestaurantModel _parseRestaurantData(String jsonData) {
    final json = jsonDecode(jsonData);
    return RestaurantModel.fromJson(_ensureSafeJson(json));
  }

  Map<String, dynamic> _ensureSafeJson(Map<String, dynamic> json) {
    // تأكد من أن جميع الحقول النصية لها قيم افتراضية
    json['color'] ??= '#000000';
    json['backgroundColor'] ??= '#FFFFFF';
    json['fColorItem'] ??= '#000000';
    json['logoHomePage'] ??= '';
    json['backgroundImageItem'] ??= '';
    // أضف باقي الحقول التي قد تكون null
    return json;
  }
}
