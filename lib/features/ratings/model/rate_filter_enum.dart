import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

enum RateFilterEnum implements DropDownItemModel{
  all,
  date,
  age,
  rate,
  gender;
  
  @override
  String get displayName => Utils.capitalizeFirst(name);
  
  @override
  int get id => index + 1;
}
