import 'package:easy_localization/easy_localization.dart';

enum RateEnum {
  bad,
  good,
  perfect;

  int get id {
    switch (this) {
      case RateEnum.bad:
        return 1;
      case RateEnum.good:
        return 2;
      case RateEnum.perfect:
        return 3;
    }
  }

  String displayName() {
    switch (this) {
      case RateEnum.bad:
        return "bad".tr();
      case RateEnum.good:
        return "good".tr();
      case RateEnum.perfect:
        return "perfect".tr();
    }
  }
}
