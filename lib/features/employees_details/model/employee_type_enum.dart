import 'package:easy_localization/easy_localization.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

enum EmployeeTypeEnum implements DropDownItemModel {
  all,
  waiter,
  shisha;

  @override
  String get displayName {
    switch (this) {
      case EmployeeTypeEnum.all:
        return "all".tr();
      case EmployeeTypeEnum.waiter:
        return "waiter".tr();
      case EmployeeTypeEnum.shisha:
        return "shisha".tr();
    }
  }

  @override
  int get id => index + 1;
}
