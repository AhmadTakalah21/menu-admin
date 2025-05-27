import 'package:easy_localization/easy_localization.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

enum IsPanoramaEnum implements DropDownItemModel {
  yes,
  no;

  @override
  String get displayName {
    switch (this) {
      case IsPanoramaEnum.yes:
        return "yes".tr();
      case IsPanoramaEnum.no:
        return "no".tr();
    }
  }

  @override
  int get id {
    switch (this) {
      case IsPanoramaEnum.yes:
        return 1;
      case IsPanoramaEnum.no:
        return 0;
    }
  }

  static IsPanoramaEnum isPanoramaEnum(int value) {
    if (value == 1) {
      return IsPanoramaEnum.yes;
    } else {
      return IsPanoramaEnum.no;
    }
  }
}
