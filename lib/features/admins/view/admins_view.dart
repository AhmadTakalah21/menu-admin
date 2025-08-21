import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:user_admin/features/admins/cubit/admins_cubit.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/features/admins/model/user_type_model/user_type_model.dart';
import 'package:user_admin/features/admins/view/widgets/admin_details_widget.dart';
import 'package:user_admin/features/admins/view/widgets/update_admin_widget.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_add_button.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';
import 'package:user_admin/global/widgets/more_options_widget.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';
import 'package:user_admin/global/widgets/switch_view_button.dart';

abstract class AdminsViewCallBacks {
  Future<void> onRefresh();
  void onAddTap();
  void onEditTap(AdminModel admin);
  void onShowDetails(AdminModel admin);
  void onDeleteTap(AdminModel admin);
  void onSaveDeleteTap(AdminModel admin);
  void onSaveActivateTap(AdminModel admin);
  void onActivateTap(AdminModel admin);
  void onTypeSelected(UserTypeModel? type);
  Future<void> onStartDateSelected();
  Future<void> onEndDateSelected();
  void onSelectPageTap(int page);
  void onSwichViewTap();
  void onMoreOptionsTap(AdminModel admin);
  void onShowFilters();
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
    return BlocProvider(
      create: (context) => get<AdminsCubit>(),
      child: AdminsPage(permissions: permissions, restaurant: restaurant),
    );
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

  bool isCardView = true;
  bool isShowFilters = false;

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
    adminsCubit.getUserTypes(isRefresh: true);
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
        return UpdateAdminView(
          adminsCubit: adminsCubit,
          selectedPage: selectedPage,
          restaurant: widget.restaurant,
        );
      },
    );
  }

  @override
  void onEditTap(AdminModel admin) {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateAdminView(
          adminsCubit: adminsCubit,
          admin: admin,
          selectedPage: selectedPage,
          restaurant: widget.restaurant,
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
  void onMoreOptionsTap(AdminModel admin) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return MoreOptionsWidget(
          item: admin,
          onShowDetailsTap: onShowDetails,
          onEditTap: onEditTap,
          onDeleteTap: onDeleteTap,
        );
      },
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
  void onTypeSelected(UserTypeModel? type) {
    adminsCubit.setUserTypeFilter(type);
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
    //adminsCubit.getUserRoles(isRefresh: true);
    adminsCubit.getUserTypes(isRefresh: true);
    adminsCubit.getAdmins(selectedPage);
  }

  @override
  void onTryAgainTap() {
    //adminsCubit.getUserRoles(isRefresh: false);
    adminsCubit.getUserTypes(isRefresh: true);
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
  void onSwichViewTap() {
    setState(() {
      isCardView = !isCardView;
    });
  }

  @override
  void onShowFilters() {
    setState(() {
      isShowFilters = !isShowFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState && state.item is AdminModel) {
          adminsCubit.getAdmins(selectedPage);
        }
      },
      child: Scaffold(
        appBar:
        MainAppBar(restaurant: widget.restaurant,
            title: "employees".tr(),
          onSearchChanged: (q) => adminsCubit.searchByName(q),
          onSearchSubmitted: (q) => adminsCubit.searchByName(q),
          onSearchClosed: () => adminsCubit.searchByName(''),
          onLanguageToggle: (loc) {
          },
        ),
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
                  if (isShowFilters) _buildFilters(),
                  BlocBuilder<AdminsCubit, GeneralAdminsState>(
                    buildWhen: (previous, current) => current is AdminsState,
                    builder: (context, state) {
                      if (state is AdminsLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is AdminsSuccess) {
                        if (isCardView) {
                          return _buildCardView(state.paginatedModel);
                        } else {
                          return _buildTableView(state.paginatedModel);
                        }
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
        floatingActionButton: _buildFloatingButtons(),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        BlocBuilder<AdminsCubit, GeneralAdminsState>(
          buildWhen: (previous, current) => current is UserTypesState,
          builder: (context, state) {
            if (state is UserTypesLoading) {
              return const LoadingIndicator(color: AppColors.black);
            } else if (state is UserTypesSuccess) {
              return MainDropDownWidget(
                items: state.userTypes,
                text: "type".tr(),
                onChanged: onTypeSelected,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        const SizedBox(height: 20),
        MainTextField(
          controller: startDateController,
          labelText: "start_date".tr(),
          readOnly: true,
          borderColor: widget.restaurant.color,
          onTap: onStartDateSelected,
          onClearTap: () {
            adminsCubit.setStartDate(null);
            setState(() {
              startDateController.text = "mm/dd/yyyy";
            });
            adminsCubit.getAdmins(selectedPage);
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
          borderColor: widget.restaurant.color,
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
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTableView(PaginatedModel<AdminModel> employees) {
    final List<String> titles = [
      "name".tr(),
      "phone_number".tr(),
      "type".tr(),
      "accept_count".tr(),
      "response_time_rate".tr(),
      "status".tr(),
      "event".tr(),
    ];

    final permissions = widget.permissions.map((e) => e.name).toSet();

    final bool isEdit = permissions.contains("user.update");
    final bool isActive = permissions.contains("user.active");
    final bool isDelete = permissions.contains("user.delete");
    List<DataRow> rows = [];
    rows = List.generate(
      employees.data.length,
          (index) {
        final employee = employees.data[index];
        final values = [
          Text(employee.name),
          Text(employee.mobile),
          Text(employee.type ?? "_"),
          Text(employee.number.toString()),
          Text(employee.avg ?? "_"),
          MainActionButton(
            padding: AppConstants.padding6,
            onPressed: () {},
            text: employee.isActive ? "active".tr() : "inactive".tr(),
            buttonColor:
            employee.isActive ? AppColors.greenShade : AppColors.red,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isActive)
                InkWell(
                  onTap: () => onActivateTap(employee),
                  child: Icon(
                    employee.isActive ? Icons.block : Icons.check_circle,
                    size: 30,
                  ),
                ),
              if (isActive) const SizedBox(width: 10),
              if (isDelete)
                InkWell(
                  onTap: () => onDeleteTap(employee),
                  child: const Icon(Icons.delete),
                ),
              if (isDelete) const SizedBox(width: 10),
              if (isEdit)
                InkWell(
                  onTap: () => onEditTap(employee),
                  child: const Icon(Icons.edit_outlined),
                ),
              if (isEdit) const SizedBox(width: 10),
              InkWell(
                onTap: () => onShowDetails(employee),
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
              return DataCell(Center(child: values[index2]));
            },
          ),
        );
      },
    );
    return Column(
      children: [
        MainDataTable(titles: titles, rows: rows,color: widget.restaurant.color,),
        SelectPageTile(
          length: employees.meta.totalPages,
          selectedPage: selectedPage,
          onSelectPageTap: onSelectPageTap,
        ),
      ],
    );
  }

  Widget _buildCardView(PaginatedModel<AdminModel> employees) {
    final permissions = widget.permissions.map((e) => e.name).toSet();

    final bool isEdit = permissions.contains("user.update");
    final bool isActive = permissions.contains("user.active");
    final bool isDelete = permissions.contains("user.delete");

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: employees.data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final employee = employees.data[index];
        Widget textWidget(String text) {
          return Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        return Container(
          decoration: const BoxDecoration(
            borderRadius: AppConstants.borderRadius25,
            color: Color(0xFFD9D9D9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.restaurant.color,
                  borderRadius: AppConstants.borderRadiusT25,
                ),
                child: Padding(
                  padding: AppConstants.paddingH12V4,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          employee.type ?? "employee".tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (isActive)
                        InkWell(
                          onTap: () => onActivateTap(employee),
                          child: Icon(
                            employee.isActive
                                ? Icons.block
                                : Icons.check_circle,
                            color: AppColors.white,
                            size: 25,
                          ),
                        ),
                      if (!isEdit && isDelete)
                        InkWell(
                          onTap: () => onShowDetails(employee),
                          child: const Icon(
                            Icons.visibility_outlined,
                            color: AppColors.white,
                          ),
                        ),
                      if (isEdit && isDelete)
                        InkWell(
                          onTap: () => onMoreOptionsTap(employee),
                          child: const Icon(
                            Icons.more_vert_outlined,
                            color: AppColors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: AppConstants.padding10,
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFBDD358)),
                        borderRadius: AppConstants.borderRadius15,
                      ),
                      child: Padding(
                        padding: AppConstants.padding8,
                        child: SvgPicture.asset("assets/images/person.svg"),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget("${"name".tr()} : ${employee.name}"),
                          textWidget(
                              "${"phone_number".tr()} : ${employee.mobile}"),
                          textWidget(
                              "${"accept_count".tr()} : ${employee.number}"),
                          textWidget(
                              "${"response_time_rate".tr()} : ${employee.avg ?? '---'}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingButtons() {
    final permissions = widget.permissions.map((e) => e.name).toSet();
    final bool isAdd = permissions.contains("user.add");
    return Row(
      children: [
        const SizedBox(width: 30),
        SwitchViewButton(
          onTap: onSwichViewTap,
          isCardView: isCardView,
          color: widget.restaurant.color,
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MainActionButton(
                  padding: AppConstants.padding10,
                  onPressed: onShowFilters,
                  text: "text",
                  buttonColor: widget.restaurant.color,
                  child: const Icon(
                    Icons.filter_alt,
                    color: AppColors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 10),
        if (isAdd)
          MainAddButton(onTap: onAddTap, color: widget.restaurant.color)
      ],
    );
  }
}
