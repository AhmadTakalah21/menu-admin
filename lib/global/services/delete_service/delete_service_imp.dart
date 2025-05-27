part of 'delete_service.dart';

@Injectable(as: DeleteService)
class DeleteServiceImp implements DeleteService {
  final dio = DioClient();

  @override
  Future<void> deleteItem<T extends DeleteModel>(T item) async {
    try {
      await dio.delete("/admin_api/${item.apiDeleteUrl}");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deactivateItem<T extends DeleteModel>(T item) async {
    try {
      await dio.post("/admin_api/${item.apiDeactivateUrl}");
    } catch (e) {
      rethrow;
    }
  }
}
