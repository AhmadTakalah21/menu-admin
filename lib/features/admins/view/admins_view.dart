import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/admins/cubit/admins_cubit.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/features/admins/model/role_enum.dart';
import 'package:user_admin/features/admins/view/widgets/admin_details_widget.dart';
import 'package:user_admin/features/admins/view/widgets/update_admin_widget.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

abstract class AdminsViewCallBacks {
  Future<void> onRefresh();

  void onAddTap();

  void onEditTap(AdminModel admin);

  void onShowDetails(AdminModel admin);

  void onDeleteTap(AdminModel admin);

  void onSaveDeleteTap(AdminModel admin);

  void onSaveActivateTap(AdminModel admin);

  void onActivateTap(AdminModel admin);

  void onRoleSelected(RoleEnum role);

  Future<void> onStartDateSelected();

  Future<void> onEndDateSelected();

  void onSelectPageTap(int page);

  void onTryAgainTap();
}

class AdminsView extends StatelessWidget {
  const AdminsView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return AdminsPage(permissions: permissions, restaurant: restaurant);
  }
}

class AdminsPage extends StatefulWidget {
  const AdminsPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<AdminsPage> createState() => _AdminsPageState();
}

class _AdminsPageState extends State<AdminsPage>
    implements AdminsViewCallBacks {
  late final AdminsCubit adminsCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();
  int selectedPage = 1;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

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
    adminsCubit.getAdmins(selectedPage);
    startDateController.text =
        "$selectedStartMonth/$selectedStartDay/$selectedStartYear";
    endDateController.text =
        "$selectedEndMonth/$selectedEndDay/$selectedEndYear";
  }

  @override
  void onAddTap() {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateAdminWidget(
          isEdit: false,
          selectedPage: selectedPage,
        );
      },
    );
  }

  @override
  void onEditTap(AdminModel admin) {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateAdminWidget(
          isEdit: true,
          admin: admin,
          selectedPage: selectedPage,
        );
      },
    );
  }

  @override
  void onActivateTap(AdminModel admin) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: false,
          item: admin,
          onSaveTap: onSaveActivateTap,
        );
      },
    );
  }

  @override
  void onDeleteTap(AdminModel admin) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: true,
          item: admin,
          onSaveTap: onSaveDeleteTap,
        );
      },
    );
  }

  @override
  void onSaveActivateTap(AdminModel admin) {
    deleteCubit.deactivateItem<AdminModel>(admin);
  }

  @override
  void onSaveDeleteTap(AdminModel admin) {
    deleteCubit.deleteItem<AdminModel>(admin);
  }

  @override
  void onShowDetails(AdminModel admin) {
    showDialog(
      context: context,
      builder: (context) => AdminDetailsWidget(admin: admin),
    );
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
      adminsCubit.setEndDate(
        Utils.convertToIsoFormat(endDateController.text),
      );
      adminsCubit.getAdmins(selectedPage);
    }
  }

  @override
  void onRoleSelected(RoleEnum? role) {
    adminsCubit.setRole(role);
    adminsCubit.getAdmins(selectedPage);
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
      adminsCubit.setStartDate(
        Utils.convertToIsoFormat(startDateController.text),
      );
      adminsCubit.getAdmins(selectedPage);
    }
  }

  @override
  Future<void> onRefresh() async {
    adminsCubit.getUserRoles(isRefresh: true);
    adminsCubit.getAdmins(selectedPage);
  }

  @override
  void onTryAgainTap() {
    adminsCubit.getUserRoles(isRefresh: false);
    adminsCubit.getAdmins(selectedPage);
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      adminsCubit.getAdmins(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "name".tr(),
      "phone_number".tr(),
      "role".tr(),
      "accept_count".tr(),
      "response_time_rate".tr(),
      "status".tr(),
      "event".tr(),
    ];

    final permissions = widget.permissions.map((e) => e.name).toSet();

    final bool isEdit = permissions.contains("user.update");
    final bool isActive = permissions.contains("user.active");
    final bool isDelete = permissions.contains("user.delete");
    final bool isAdd = permissions.contains("user.add");

    final restColor = widget.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState && state.item is AdminModel) {
          adminsCubit.getAdmins(selectedPage);
        }
      },
      child: Scaffold(
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
                  MainBackButton(color: restColor),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "admins".tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (isAdd)
                        MainActionButton(
                          padding: AppConstants.padding10,
                          onPressed: onAddTap,
                          text: "add_order".tr(),
                          child: const Icon(
                            Icons.add_circle,
                            color: AppColors.white,
                          ),
                        ),
                      if (isAdd) const SizedBox(width: 10),
                      MainActionButton(
                        padding: AppConstants.padding10,
                        onPressed: onRefresh,
                        text: "",
                        child:
                            const Icon(Icons.refresh, color: AppColors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: AppConstants.paddingH20,
                    child: Column(
                      children: [
                        MainDropDownWidget<RoleEnum>(
                          items: RoleEnum.values,
                          text: "role".tr(),
                          onChanged: onRoleSelected,
                          focusNode: FocusNode(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: startDateController,
                          labelText: "start_date".tr(),
                          readOnly: true,
                          onTap: onStartDateSelected,
                          onClearTap: () {
                            adminsCubit.setStartDate(null);
                            setState(() {
                              startDateController.text = "mm/dd/yyyy";
                            });
                            adminsCubit.getAdmins(selectedPage);
                          },
                          showCloseIcon:
                              startDateController.text != "mm/dd/yyyy",
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
                            adminsCubit.setEndDate(null);
                            setState(() {
                              endDateController.text = "mm/dd/yyyy";
                            });
                            adminsCubit.getAdmins(selectedPage);
                          },
                          showCloseIcon: endDateController.text != "mm/dd/yyyy",
                          suffixIcon: IconButton(
                            onPressed: onEndDateSelected,
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AdminsCubit, GeneralAdminsState>(
                    buildWhen: (previous, current) => current is AdminsState,
                    builder: (context, state) {
                      if (state is AdminsLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is AdminsSuccess) {
                        List<DataRow> rows = [];
                        rows = List.generate(
                          state.paginatedModel.data.length,
                          (index) {
                            final admin = state.paginatedModel.data[index];
                            final values = [
                              Text(admin.name),
                              Text(admin.mobile),
                              Text(admin.roles ?? "_"),
                              Text(admin.number.toString()),
                              Text(admin.avg ?? "_"),
                              MainActionButton(
                                padding: AppConstants.padding6,
                                onPressed: () {},
                                text: admin.isActive
                                    ? "active".tr()
                                    : "inactive".tr(),
                                buttonColor: admin.isActive
                                    ? AppColors.greenShade
                                    : AppColors.red,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isActive)
                                    InkWell(
                                      onTap: () => onActivateTap(admin),
                                      child: Icon(
                                        admin.isActive
                                            ? Icons.block
                                            : Icons.check_circle,
                                        size: 30,
                                      ),
                                    ),
                                  if (isActive) const SizedBox(width: 10),
                                  if (isDelete)
                                    InkWell(
                                      onTap: () => onDeleteTap(admin),
                                      child: const Icon(Icons.delete),
                                    ),
                                  if (isDelete) const SizedBox(width: 10),
                                  if (isEdit)
                                    InkWell(
                                      onTap: () => onEditTap(admin),
                                      child: const Icon(Icons.edit_outlined),
                                    ),
                                  if (isEdit) const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () => onShowDetails(admin),
                                    child: const Icon(Icons.remove_red_eye),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              )
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
                      } else if (state is AdminsEmpty) {
                        return Center(child: Text(state.message));
                      } else if (state is AdminsFail) {
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
      ),
    );
  }
}
