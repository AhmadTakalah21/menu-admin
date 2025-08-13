import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';

part 'add_order_service_imp.dart';

abstract class AddOrderService {
  Future<List<CategoryModel>> getCategoriesSubsItems(int restaurantId);

  Future<void> addOrder(Map<String, dynamic> order);
}
