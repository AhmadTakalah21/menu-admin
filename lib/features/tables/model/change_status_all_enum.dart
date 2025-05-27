import 'package:easy_localization/easy_localization.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

enum ChangeStatusAllEnum implements DropDownItemModel {
  accepted,
  preparation,
  done;

  @override
  String get displayName {
    switch (this) {
      case ChangeStatusAllEnum.accepted:
        return "accept_all".tr();
      case ChangeStatusAllEnum.preparation:
        return "preparing_all".tr();
      case ChangeStatusAllEnum.done:
        return "done_all".tr();
    }
  }

  @override
  int get id => index + 1;
}
