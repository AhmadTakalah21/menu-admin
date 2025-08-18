import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/admins/cubit/admins_cubit.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/features/employees_details/cubit/employees_details_cubit.dart';
import 'package:user_admin/features/employees_details/model/employee_type_enum.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
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

abstract class EmployeesDetailsViewCallBacks {
  Future<void> onRefresh();

  Future<void> onDateSelected();

  void onShowFilters();

  void onSelectPageTap(int page);

  void onSearchSubmitted(String search);

  void onSearchonChanged(String search);

  void onEmployeeChanged(AdminModel? employee);

  void onTableChanged(TableModel? table);

  void onTypeChanged(EmployeeTypeEnum? type);

  void onTryAgainTap();
}

class EmployeesDetailsView extends StatelessWidget {
  const EmployeesDetailsView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return EmployeesDetailsPage(
      permissions: permissions,
      restaurant: restaurant,
    );
  }
}

class EmployeesDetailsPage extends StatefulWidget {
  const EmployeesDetailsPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<EmployeesDetailsPage> createState() => _EmployeesDetailsPageState();
}

class _EmployeesDetailsPageState extends State<EmployeesDetailsPage>
    implements EmployeesDetailsViewCallBacks {
  late final EmployeesDetailsCubit employeesDetailsCubit = context.read();
  late final ItemsCubit itemsCubit = context.read();
  late final AdminsCubit adminsCubit = context.read();

  bool isShowFilters = false;

  int selectedPage = 1;

  final dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedMonth = "mm";
  String selectedDay = "dd";
  String selectedYear = "yyyy";

  @override
  void initState() {
    super.initState();
    employeesDetailsCubit.getEmployees(selectedPage);
    adminsCubit.getAdmins(1);
    itemsCubit.getTables();

    dateController.text = "$selectedMonth/$selectedDay/$selectedYear";
  }

  @override
  Future<void> onDateSelected() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        selectedDate = dateTime;
        selectedMonth = dateTime.month.toString();
        selectedDay = dateTime.day.toString();
        selectedYear = dateTime.year.toString();
        dateController.text = "$selectedMonth/$selectedDay/$selectedYear";
      });
      employeesDetailsCubit.setDate(
        Utils.convertToIsoFormat(dateController.text),
      );
      employeesDetailsCubit.getEmployees(selectedPage);
    }
  }

  @override
  void onShowFilters() {
    setState(() {
      isShowFilters = !isShowFilters;
    });
  }

  @override
  void onSearchSubmitted(String search) {
    employeesDetailsCubit.setSearch(search);
    employeesDetailsCubit.getEmployees(selectedPage);
  }

  @override
  void onSearchonChanged(String search) {
    if (search.isEmpty) {
      employeesDetailsCubit.setSearch(search);
      employeesDetailsCubit.getEmployees(selectedPage);
    }
  }

  @override
  void onEmployeeChanged(AdminModel? employee) {
    employeesDetailsCubit.setEmployeeId(employee?.id);
    employeesDetailsCubit.getEmployees(selectedPage);
  }

  @override
  void onTableChanged(TableModel? table) {
    employeesDetailsCubit.setTableId(table?.id);
    employeesDetailsCubit.getEmployees(selectedPage);
  }

  @override
  void onTypeChanged(EmployeeTypeEnum? type) {
    employeesDetailsCubit.setType(type);
    employeesDetailsCubit.getEmployees(selectedPage);
  }

  @override
  Future<void> onRefresh() async {
    dateController.clear();
    employeesDetailsCubit.resetParams();
    employeesDetailsCubit.getEmployees(selectedPage);
    adminsCubit.getAdmins(1);
    itemsCubit.getTables();
  }

  @override
  void onTryAgainTap() {
    employeesDetailsCubit.getEmployees(selectedPage);
    adminsCubit.getAdmins(1);
    itemsCubit.getTables();
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      employeesDetailsCubit.getEmployees(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "name".tr(),
      "role".tr(),
      "table_num".tr(),
      "response_time".tr(),
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
                      "employees_details".tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    MainActionButton(
                      padding: AppConstants.padding8,
                      onPressed: onShowFilters,
                      text: "text",
                      child: const Icon(
                        Icons.filter_alt,
                        color: AppColors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    MainActionButton(
                      padding: AppConstants.padding10,
                      onPressed: onRefresh,
                      text: "",
                      child: const Icon(Icons.refresh, color: AppColors.white),
                    ),
                  ],
                ),
                if (isShowFilters)
                  Padding(
                    padding: AppConstants.paddingH20,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        MainTextField(
                          hintText: "search".tr(),
                          onChanged: onSearchonChanged,
                          onSubmitted: onSearchSubmitted,
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<AdminsCubit, GeneralAdminsState>(
                          builder: (context, state) {
                            if (state is AdminsLoading) {
                              return const LoadingIndicator(
                                  color: AppColors.black);
                            } else if (state is AdminsSuccess) {
                              return MainDropDownWidget<AdminModel>(
                                items: state.paginatedModel.data,
                                text: "employee".tr(),
                                onChanged: onEmployeeChanged,
                                focusNode: FocusNode(),
                              );
                            } else if (state is AdminsEmpty) {
                              return Text(state.message);
                            } else if (state is AdminsFail) {
                              return MainErrorWidget(
                                error: state.error,
                                onTryAgainTap: onTryAgainTap,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        MainDropDownWidget<EmployeeTypeEnum>(
                          items: EmployeeTypeEnum.values,
                          text: "type".tr(),
                          onChanged: onTypeChanged,
                          focusNode: FocusNode(),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<ItemsCubit, GeneralItemsState>(
                          builder: (context, state) {
                            if (state is TablesLoading) {
                              return const LoadingIndicator(
                                  color: AppColors.black);
                            } else if (state is TablesSuccess) {
                              return MainDropDownWidget<TableModel>(
                                items: state.tables.data,
                                text: "table".tr(),
                                onChanged: onTableChanged,
                                focusNode: FocusNode(),
                              );
                            } else if (state is TablesEmpty) {
                              return Text(state.message);
                            } else if (state is TablesFail) {
                              return MainErrorWidget(
                                error: state.error,
                                onTryAgainTap: onTryAgainTap,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: dateController,
                          labelText: "date".tr(),
                          readOnly: true,
                          onTap: onDateSelected,
                          onClearTap: () {
                            employeesDetailsCubit.setDate(null);
                            setState(() {
                              dateController.text = "mm/dd/yyyy";
                            });
                            employeesDetailsCubit.getEmployees(selectedPage);
                          },
                          showCloseIcon: dateController.text != "mm/dd/yyyy",
                          suffixIcon: IconButton(
                            onPressed: onDateSelected,
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                BlocBuilder<EmployeesDetailsCubit,
                    GeneralEmployeesDetailsState>(
                  buildWhen: (previous, current) =>
                      current is EmployeesDetailsState,
                  builder: (context, state) {
                    if (state is EmployeesDetailsLoading) {
                      return const LoadingIndicator(color: AppColors.black);
                    } else if (state is EmployeesDetailsSuccess) {
                      List<DataRow> rows = [];
                      rows = List.generate(
                        state.paginatedModel.data.length,
                        (index) {
                          final details = state.paginatedModel.data[index];
                          final values = [
                            Text(details.name),
                            Text(details.type),
                            Text(details.numberTable.toString()),
                            Text(details.responseTime),
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
                    } else if (state is EmployeesDetailsEmpty) {
                      return Center(child: Text(state.message));
                    } else if (state is EmployeesDetailsFail) {
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
