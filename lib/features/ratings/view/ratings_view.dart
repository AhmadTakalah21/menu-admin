import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:user_admin/features/ratings/cubit/ratings_cubit.dart';
import 'package:user_admin/features/ratings/model/gender_enum.dart';
import 'package:user_admin/features/ratings/model/rate_enum.dart';
import 'package:user_admin/features/ratings/model/rate_filter_enum.dart';

import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';

import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

import '../../../global/widgets/main_app_bar.dart';

abstract class RatingsViewCallBacks {
  Future<void> onRefresh();
  Future<void> onStartDateSelected();
  Future<void> onEndDateSelected();
  void onFilterTypeSelected(RateFilterEnum? rateFilter);
  void onSetKnown();
  void onSetUnknown();
  void increaseFromAge();
  void decreaseFromAge();
  void increaseToAge();
  void decreaseToAge();
  void onFromAgeSubmitted(String age);
  void onToAgeSubmitted(String age);
  void onFromAgeChanged(String age);
  void onToAgeChanged(String age);
  void onSelectPageTap(int page);
  void onGenderSelected(GenderEnum? value);
  void setRate(RateEnum rateEnum);
  bool isRatingSelected(RateEnum current);
  bool isRatingShow(RateEnum current, RateEnum rate);
  void onTryAgainTap();
}

class RatingsView extends StatelessWidget {
  const RatingsView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return RatingsPage(permissions: permissions, restaurant: restaurant);
  }
}

class RatingsPage extends StatefulWidget {
  const RatingsPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage>
    implements RatingsViewCallBacks {
  late final RatingsCubit ratingsCubit = context.read();

  int selectedPage = 1;
  bool isKnown = true;
  GenderEnum? currentGender = GenderEnum.male;
  RateFilterEnum? rateFilter = RateFilterEnum.all;
  RateEnum? selectedRate;
  int fromAge = 0;
  int toAge = 0;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final fromAgeController = TextEditingController();
  final toAgeController = TextEditingController();

  DateTime selectedStartDate = DateTime.now();
  String selectedStartMonth = "mm";
  String selectedStartDay = "dd";
  String selectedStartYear = "yyyy";

  DateTime selectedEndDate = DateTime.now();
  String selectedEndMonth = "mm";
  String selectedEndDay = "dd";
  String selectedEndYear = "yyyy";

  @override
  void initState() {
    super.initState();
    ratingsCubit.getRatings(selectedPage);
    startDateController.text =
    "$selectedStartMonth/$selectedStartDay/$selectedStartYear";
    endDateController.text =
    "$selectedEndMonth/$selectedEndDay/$selectedEndYear";
  }

  @override
  Future<void> onEndDateSelected() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        selectedEndDate = dateTime;
        selectedEndMonth = dateTime.month.toString();
        selectedEndDay = dateTime.day.toString();
        selectedEndYear = dateTime.year.toString();
        endDateController.text =
        "$selectedEndMonth/$selectedEndDay/$selectedEndYear";
      });
      ratingsCubit.setToDate(
        Utils.convertToIsoFormat(endDateController.text),
      );
      ratingsCubit.getRatings(selectedPage);
    }
  }

  @override
  Future<void> onStartDateSelected() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        selectedStartDate = dateTime;
        selectedStartMonth = dateTime.month.toString();
        selectedStartDay = dateTime.day.toString();
        selectedStartYear = dateTime.year.toString();
        startDateController.text =
        "$selectedStartMonth/$selectedStartDay/$selectedStartYear";
      });
      ratingsCubit.setFromDate(
        Utils.convertToIsoFormat(startDateController.text),
      );
      ratingsCubit.getRatings(selectedPage);
    }
  }

  @override
  void onFilterTypeSelected(RateFilterEnum? rateFilter) {
    setState(() {
      this.rateFilter = rateFilter;
    });
    if (rateFilter == RateFilterEnum.all) {
      startDateController.text = "mm/dd/yyyy";
      endDateController.text = "mm/dd/yyyy";
      fromAgeController.clear();
      toAgeController.clear();
      fromAge = 0;
      toAge = 0;

      ratingsCubit.resetParams();
      ratingsCubit.getRatings(selectedPage);
    }
  }

  @override
  void onSetKnown() {
    setState(() {
      isKnown = true;
    });
    ratingsCubit.setType("person");
    ratingsCubit.getRatings(selectedPage);
  }

  @override
  void onSetUnknown() {
    setState(() {
      isKnown = false;
    });
    ratingsCubit.setType("unknown");
    ratingsCubit.getRatings(selectedPage);
  }

  @override
  void decreaseFromAge() {
    if (fromAge > 0) {
      fromAge--;
    }
    fromAgeController.text = fromAge.toString();
  }

  @override
  void decreaseToAge() {
    if (toAge > 0) {
      toAge--;
    }
    toAgeController.text = toAge.toString();
  }

  @override
  void increaseFromAge() {
    fromAge++;
    fromAgeController.text = fromAge.toString();
  }

  @override
  void increaseToAge() {
    toAge++;
    toAgeController.text = toAge.toString();
  }

  @override
  void onFromAgeSubmitted(String age) {
    final int? fromAgeParam;
    if (fromAgeController.text.isEmpty) {
      fromAgeParam = null;
    } else {
      fromAgeParam = int.parse(fromAgeController.text);
    }
    ratingsCubit.setFromAge(fromAgeParam);
    ratingsCubit.getRatings(selectedPage);
  }

  @override
  void onToAgeSubmitted(String age) {
    final int? toAgeParam;
    if (toAgeController.text.isEmpty) {
      toAgeParam = null;
    } else {
      toAgeParam = int.parse(toAgeController.text);
    }
    ratingsCubit.setToAge(toAgeParam);
    ratingsCubit.getRatings(selectedPage);
  }

  @override
  void onFromAgeChanged(String age) {
    final int? fromAgeParam;
    if (age.isEmpty) {
      fromAgeParam = null;
    } else {
      fromAgeParam = int.parse(age);
    }
    ratingsCubit.setFromAge(fromAgeParam);
  }

  @override
  void onToAgeChanged(String age) {
    final int? toAgeParam;
    if (age.isEmpty) {
      toAgeParam = null;
    } else {
      toAgeParam = int.parse(age);
    }
    ratingsCubit.setToAge(toAgeParam);
  }

  @override
  void onGenderSelected(GenderEnum? value) {
    setState(() {
      currentGender = value;
    });
    ratingsCubit.setGender(value);
    ratingsCubit.getRatings(selectedPage);
  }

  @override
  bool isRatingSelected(RateEnum current) {
    final selectedRate = this.selectedRate;
    if (selectedRate == null) return false;
    return current.index <= selectedRate.index;
  }

  @override
  bool isRatingShow(RateEnum current, RateEnum rate) {
    return rate.index <= current.index;
  }

  @override
  void setRate(RateEnum rateEnum) {
    if (selectedRate == rateEnum && rateEnum == RateEnum.bad) {
      setState(() {
        selectedRate = null;
        ratingsCubit.setRate(null);
      });
    } else {
      setState(() {
        selectedRate = rateEnum;
        ratingsCubit.setRate(rateEnum);
      });
    }
    ratingsCubit.getRatings(selectedPage);
  }

  @override
  Future<void> onRefresh() async {
    ratingsCubit.getRatings(selectedPage);
  }

  @override
  void onTryAgainTap() {
    ratingsCubit.getRatings(selectedPage);
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      ratingsCubit.getRatings(page);
    }
  }

  int _columnsForWidth(double w) => w >= 520 ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    final restColor = widget.restaurant.color;

    return Scaffold(
      appBar: MainAppBar(restaurant: widget.restaurant, title: "ratings".tr()),
    drawer: MainDrawer(
        permissions: widget.permissions,
        restaurant: widget.restaurant,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: AppConstants.padding16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainDropDownWidget<RateFilterEnum>(
                  items: RateFilterEnum.values,
                  text: "select_filter_type".tr(),
                  onChanged: onFilterTypeSelected,
                  focusNode: FocusNode(),
                  selectedValue: rateFilter,
                ),

                if (rateFilter == RateFilterEnum.date)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      MainTextField(
                        controller: startDateController,
                        labelText: "start_date".tr(),
                        readOnly: true,
                        onTap: onStartDateSelected,
                        onClearTap: () {
                          ratingsCubit.setFromDate(null);
                          setState(() {
                            startDateController.text = "mm/dd/yyyy";
                          });
                          ratingsCubit.getRatings(selectedPage);
                        },
                        showCloseIcon: startDateController.text != "mm/dd/yyyy",
                        suffixIcon: IconButton(
                          onPressed: onStartDateSelected,
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MainTextField(
                        controller: endDateController,
                        labelText: "end_date".tr(),
                        readOnly: true,
                        onTap: onEndDateSelected,
                        onClearTap: () {
                          ratingsCubit.setToDate(null);
                          setState(() {
                            endDateController.text = "mm/dd/yyyy";
                          });
                          ratingsCubit.getRatings(selectedPage);
                        },
                        showCloseIcon: endDateController.text != "mm/dd/yyyy",
                        suffixIcon: IconButton(
                          onPressed: onEndDateSelected,
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ],
                  ),

                if (rateFilter == RateFilterEnum.age)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      MainTextField(
                        controller: fromAgeController,
                        labelText: "from_age".tr(),
                        textInputType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: onFromAgeChanged,
                        onSubmitted: onFromAgeSubmitted,
                        suffixIcon: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: increaseFromAge,
                              child: const Icon(Icons.arrow_drop_up),
                            ),
                            InkWell(
                              onTap: decreaseFromAge,
                              child: const Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      MainTextField(
                        controller: toAgeController,
                        labelText: "to_age".tr(),
                        textInputType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: onToAgeChanged,
                        onSubmitted: onToAgeSubmitted,
                        suffixIcon: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: increaseToAge,
                              child: const Icon(Icons.arrow_drop_up),
                            ),
                            InkWell(
                              onTap: decreaseToAge,
                              child: const Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                if (rateFilter == RateFilterEnum.rate)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: RateEnum.values
                              .map(
                                (ratingEnum) => InkWell(
                              onTap: () => setRate(ratingEnum),
                              child: Icon(
                                Icons.star,
                                size: 40,
                                color: isRatingSelected(ratingEnum)
                                    ? Colors.yellow
                                    : AppColors.greyShade5,
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                if (rateFilter == RateFilterEnum.gender)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: GenderEnum.values.map((gender) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(gender.name),
                              Radio(
                                value: gender,
                                groupValue: currentGender,
                                onChanged: onGenderSelected,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    MainActionButton(
                      padding: AppConstants.padding8,
                      onPressed: onSetKnown,
                      text: "known_rate".tr(),
                      buttonColor:
                      isKnown ? AppColors.blueShade3 : AppColors.white,
                      textColor:
                      isKnown ? AppColors.white : AppColors.blueShade3,
                      border: Border.all(color: AppColors.blueShade3),
                    ),
                    const SizedBox(width: 10),
                    MainActionButton(
                      padding: AppConstants.padding8,
                      onPressed: onSetUnknown,
                      text: "unknown_rate".tr(),
                      buttonColor:
                      isKnown ? AppColors.white : AppColors.blueShade3,
                      textColor:
                      isKnown ? AppColors.blueShade3 : AppColors.white,
                      border: Border.all(color: AppColors.blueShade3),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                BlocBuilder<RatingsCubit, GeneralRatingsState>(
                  buildWhen: (previous, current) => current is RatingsState,
                  builder: (context, state) {
                    if (state is RatingsLoading) {
                      return const LoadingIndicator(color: AppColors.black);
                    } else if (state is RatingsSuccess) {
                      final data = state.paginatedModel.data;

                      return Column(
                        children: [
                          LayoutBuilder(
                            builder: (context, cons) {
                              final cols = _columnsForWidth(cons.maxWidth);
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.86,
                                ),
                                itemCount: data.length,
                                itemBuilder: (_, i) {
                                  final r = data[i];
                                  final rateEnum = r.rate == 1
                                      ? RateEnum.bad
                                      : (r.rate == 2
                                      ? RateEnum.good
                                      : RateEnum.perfect);

                                  return _RatingCard(
                                    brand: widget.restaurant.color ??
                                        const Color(0xFF2E4D2F),
                                    name: r.name,
                                    phone: r.phone,
                                    note: r.note,
                                    birthday: r.birthday?.toString(),
                                    rate: rateEnum,
                                  );
                                },
                              );
                            },
                          ),
                          if (state.paginatedModel.meta.totalPages > 1) ...[
                            const SizedBox(height: 12),
                            SelectPageTile(
                              length: state.paginatedModel.meta.totalPages,
                              selectedPage: selectedPage,
                              onSelectPageTap: onSelectPageTap,
                            ),
                          ],
                        ],
                      );
                    } else if (state is RatingsEmpty) {
                      return Center(child: Text(state.message));
                    } else if (state is RatingsFail) {
                      return Center(
                        child: MainErrorWidget(
                          error: state.error,
                          onTryAgainTap: onTryAgainTap,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================  Widgets المظهر  =====================

class _RatingCard extends StatelessWidget {
  const _RatingCard({
    required this.brand,
    required this.name,
    required this.phone,
    required this.note,
    required this.birthday,
    required this.rate,
  });

  final Color brand;
  final String? name;
  final String? phone;
  final String? note;
  final String? birthday;
  final RateEnum rate;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.black.withOpacity(.10), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // ترويسة النجوم
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerRight,
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Center(child:  Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Star(filled: rate.index >= RateEnum.perfect.index),
                    const SizedBox(width: 8),
                    _Star(filled: rate.index >= RateEnum.good.index),
                    const SizedBox(width: 8),
                    _Star(filled: rate.index >= RateEnum.bad.index),
                  ].reversed.toList(),
                ),),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                child: _GreenInfoCard(
                  name: name,
                  phone: phone,
                  note: note,
                  birthday: birthday,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({required this.filled});
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      size: 22,
      color: filled ? Colors.amber : Colors.grey.shade400,
    );
  }
}

class _GreenInfoCard extends StatelessWidget {
  const _GreenInfoCard({
    this.name,
    this.phone,
    this.note,
    this.birthday,
  });

  final String? name;
  final String? phone;
  final String? note;
  final String? birthday;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC7D86B),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Column(
          children: [
            _FieldLine(label: 'الاسم', value: name),
            const SizedBox(height: 8),
            _FieldLine(label: 'الرقم', value: phone),
            const SizedBox(height: 8),
            _FieldLine(label: 'العمر', value: _ageFrom(birthday)),
            const SizedBox(height: 8),
            _FieldLine(label: 'الملاحظات', value: note, maxLines: 2),
          ],
        ),
      ),
    );
  }

  String? _ageFrom(String? bday) {
    if (bday == null || bday.isEmpty) return null;
    final dt = DateTime.tryParse(bday);
    if (dt == null) return bday;
    final now = DateTime.now();
    var age = now.year - dt.year;
    if (now.month < dt.month || (now.month == dt.month && now.day < dt.day)) {
      age--;
    }
    return '$age';
  }
}


class _FieldLine extends StatelessWidget {
  const _FieldLine({
    required this.label,
    this.value,
    this.maxLines = 1,
  });

  final String label;
  final String? value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final v = (value == null || value!.trim().isEmpty) ? '—' : value!.trim();
    return Row(
      children: [
        Text(
          '$label : ',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              const _DashedLine(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  v,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      const dashWidth = 4.0;
      const dashSpace = 3.0;
      final dashes = (c.maxWidth / (dashWidth + dashSpace)).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          dashes,
              (_) => Container(
            width: dashWidth,
            height: 1.2,
            color: Colors.black54,
          ),
        ),
      );
    });
  }
}
