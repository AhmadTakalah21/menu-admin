import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "name".tr(),
      "note".tr(),
      "num".tr(),
      "gender".tr(),
      "age".tr(),
      "rating".tr(),
    ];
    final restColor = widget.restaurant.color;
    return Scaffold(
      appBar: AppBar(),
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
                MainBackButton(color: restColor!),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "ratings".tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    MainActionButton(
                      padding: AppConstants.padding10,
                      onPressed: onRefresh,
                      text: "",
                      child: const Icon(Icons.refresh, color: AppColors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                          children: RateEnum.values.map(
                            (ratingEnum) {
                              return InkWell(
                                onTap: () => setRate(ratingEnum),
                                child: Icon(
                                  Icons.star,
                                  size: 40,
                                  color: isRatingSelected(ratingEnum)
                                      ? Colors.yellow
                                      : AppColors.greyShade5,
                                ),
                              );
                            },
                          ).toList(),
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
                        children: GenderEnum.values.map(
                          (gender) {
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
                          },
                        ).toList(),
                      )
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
                      List<DataRow> rows = [];
                      rows = List.generate(
                        state.paginatedModel.data.length,
                        (index) {
                          final rate = state.paginatedModel.data[index];
                          final values = [
                            Text(rate.name),
                            Text(rate.note),
                            Text(rate.phone),
                            Text(rate.gender),
                            Text(rate.birthday.toString()),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: RateEnum.values.map(
                                (ratingEnum) {
                                  final rateEnum = rate.rate == 1
                                      ? RateEnum.bad
                                      : rate.rate == 2
                                          ? RateEnum.good
                                          : RateEnum.perfect;
                                  return Icon(
                                    Icons.star,
                                    size: 20,
                                    color: isRatingShow(rateEnum, ratingEnum)
                                        ? Colors.yellow
                                        : AppColors.greyShade5,
                                  );
                                },
                              ).toList(),
                            ),
                          ];
                          return DataRow(
                            cells: List.generate(
                              values.length,
                              (index2) {
                                return DataCell(
                                  Center(child: values[index2]),
                                );
                              },
                            ),
                          );
                        },
                      );
                      return Column(
                        children: [
                          MainDataTable(titles: titles, rows: rows),
                          SelectPageTile(
                            length: state.paginatedModel.meta.totalPages,
                            selectedPage: selectedPage,
                            onSelectPageTap: onSelectPageTap,
                          ),
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
