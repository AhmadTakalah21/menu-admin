import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

enum OrderStatusEnum implements DropDownItemModel {
  waiting,
  accepted,
  preparation,
  done;

  @override
  String get displayName => name[0].toUpperCase() + name.substring(1);

  @override
  int get id => index + 1;

  static OrderStatusEnum? getStatus(String status) {
    switch (status) {
      case "waiting":
        return OrderStatusEnum.waiting;
      case "accepted":
        return OrderStatusEnum.accepted;
      case "preparation":
        return OrderStatusEnum.preparation;
      case "done":
        return OrderStatusEnum.done;
    }
    return null;
  }
}
