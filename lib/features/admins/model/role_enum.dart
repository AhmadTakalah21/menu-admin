import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

enum RoleEnum implements DropDownItemModel {
  all,
  admin,
  employee;

  @override
  int get id => index;
  
  @override
  String get displayName => Utils.capitalizeFirst(name);
}
