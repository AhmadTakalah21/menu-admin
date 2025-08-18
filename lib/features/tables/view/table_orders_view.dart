import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/customer_service/cubit/customer_service_cubit.dart';
import 'package:user_admin/features/tables/cubit/tables_cubit.dart';
import 'package:user_admin/features/tables/model/change_status_all_enum.dart';
import 'package:user_admin/features/tables/model/order_details_model/order_details_model.dart';
import 'package:user_admin/features/tables/view/widgets/edit_order_in_table_widget.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/add_service_to_order_widget.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

abstract class TableOrdersViewCallBacks {
  void onAddOrderTap();

  void onAddServiceTap();

  void onEditTap(OrderDetailsModel orderDetailsModel);

  void onDeleteTap(OrderDetailsModel orderDetailsModel);

  void onSaveDeleteTap(OrderDetailsModel orderDetailsModel);

  void onSelectPageTap(int page);

  void onSelectChangeStatusToAll(ChangeStatusAllEnum? status);

  void changeStatusToAll(ChangeStatusAllEnum? status);

  void onIgnoreTap();

  Future<void> onRefresh();

  void onTryAgainTap();
}

class TableOrdersView extends StatelessWidget {
  const TableOrdersView({
    super.key,
    required this.table,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;
  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return TablesPage(
      table: table,
      permissions: permissions,
      restaurant: restaurant,
    );
  }
}

class TablesPage extends StatefulWidget {
  const TablesPage({
    super.key,
    required this.table,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;
  final TableModel table;

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage>
    implements TableOrdersViewCallBacks {
  late final TablesCubit tablesCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();
  late final CustomerServiceCubit customerServiceCubit = context.read();

  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    tablesCubit.getTableOrders(widget.table.id, page: selectedPage);
    customerServiceCubit.getServices();
  }

  @override
  void onDeleteTap(OrderDetailsModel orderDetailsModel) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: true,
          item: orderDetailsModel,
          onSaveTap: onSaveDeleteTap,
        );
      },
    );
  }

  @override
  void onSaveDeleteTap(OrderDetailsModel orderDetailsModel) {
    deleteCubit.deleteItem<OrderDetailsModel>(orderDetailsModel);
  }

  @override
  void onEditTap(OrderDetailsModel orderDetailsModel) {
    showDialog(
      context: context,
      builder: (context) => EditOrderInTableWidget(
        selectedPage: selectedPage,
        isEdit: true,
        orderDetailsModel: orderDetailsModel,
        table: widget.table,
        restaurantId: widget.restaurant.id,
      ),
    );
  }

  @override
  void onAddOrderTap() {
    showDialog(
      context: context,
      builder: (context) => EditOrderInTableWidget(
        selectedPage: selectedPage,
        isEdit: false,
        table: widget.table,
        restaurantId: widget.restaurant.id,
      ),
    );
  }

  @override
  void onAddServiceTap() {
    showDialog(
      context: context,
      builder: (context) => AddServiceToOrderWidget(
        isTable: true,
        id: widget.table.id,
        onSuccess: onTryAgainTap,
      ),
    );
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      tablesCubit.getTableOrders(widget.table.id, page: page);
    }
  }

  @override
  void changeStatusToAll(ChangeStatusAllEnum? status) {
    tablesCubit.acceptAllOrders(widget.table.id, status: status?.name);
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void onSelectChangeStatusToAll(ChangeStatusAllEnum? status) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: AppConstants.padding16,
          titleTextStyle: const TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          title: Center(child: Text("are_you_sure".tr())),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [Divider()],
          ),
          actions: [
            BlocConsumer<TablesCubit, GeneralTablesState>(
              listener: (context, state) {
                if (state is AcceptAllSuccess) {
                  MainSnackBar.showSuccessMessage(
                    context,
                    state.message,
                  );
                  tablesCubit.getTableOrders(
                    widget.table.id,
                    page: selectedPage,
                  );
                } else if (state is AcceptAllFail) {
                  MainSnackBar.showErrorMessage(context, state.error);
                }
              },
              builder: (context, state) {
                var onTap = changeStatusToAll;
                Widget? child;
                if (state is AcceptAllLoading) {
                  onTap = (value) {};
                  child = const LoadingIndicator(size: 20);
                }
                return MainActionButton(
                  padding: AppConstants.paddingH36V12,
                  onPressed: () => onTap(status),
                  text: "yes".tr(),
                  child: child,
                );
              },
            ),
            MainActionButton(
              padding: AppConstants.paddingH36V12,
              onPressed: onIgnoreTap,
              text: "no".tr(),
            ),
          ],
        );
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    tablesCubit.getTableOrders(widget.table.id);
  }

  @override
  void onTryAgainTap() {
    tablesCubit.getTableOrders(widget.table.id, page: selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "product_name".tr(),
      "price".tr(),
      "quantity".tr(),
      "table_num".tr(),
      "order_date".tr(),
      "order_state".tr(),
    ];
    int addIndex = widget.permissions.indexWhere(
          (element) => element.name == "order.add",
    );
    int editIndex = widget.permissions.indexWhere(
          (element) => element.name == "order.update",
    );
    int deleteIndex = widget.permissions.indexWhere(
          (element) => element.name == "order.delete",
    );
    int addServiceIndex = widget.permissions.indexWhere(
          (element) => element.name == "service.add",
    );
    bool isAdd = addIndex != -1;
    bool isEdit = editIndex != -1;
    bool isDelete = deleteIndex != -1;
    bool isAddService = addServiceIndex != -1;

    if (isEdit || isDelete) {
      titles.add("event".tr());
    }
    final restColor = widget.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState) {
          tablesCubit.getTableOrders(widget.table.id, page: selectedPage);
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainBackButton(color: restColor),
                      Text(
                        "orders".tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      MainActionButton(
                        padding: AppConstants.padding10,
                        onPressed: onRefresh,
                        text: "",
                        child:
                        const Icon(Icons.refresh, color: AppColors.white),
                      ),
                      const SizedBox(width: 10),
                      if (isAddService)
                        MainActionButton(
                          padding: AppConstants.padding10,
                          onPressed: onAddServiceTap,
                          text: "add_service".tr(),
                          icon: const Icon(
                            Icons.settings,
                            color: AppColors.white,
                          ),
                        ),
                      if (isAddService) const SizedBox(width: 5),
                      if (isAdd)
                        MainActionButton(
                          padding: AppConstants.padding10,
                          onPressed: onAddOrderTap,
                          text: "add_order".tr(),
                          child: const Icon(
                            Icons.add_circle,
                            color: AppColors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (isEdit)
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: MainDropDownWidget(
                            items: ChangeStatusAllEnum.values,
                            text: "apply_status_to_all".tr(),
                            onChanged: onSelectChangeStatusToAll,
                            focusNode: FocusNode(),
                            color: AppColors.white,
                            backgrounColor: AppColors.mainColor,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  if (isEdit) const SizedBox(height: 20),
                  BlocBuilder<TablesCubit, GeneralTablesState>(
                    buildWhen: (previous, current) =>
                    current is TableOrdersState,
                    builder: (context, state) {
                      List<DataRow> rows = [];
                      if (state is TableOrdersLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is TableOrdersSuccess) {
                        rows = List.generate(
                          state.tableOrders.data.length,
                              (index) {
                            final order = state.tableOrders.data[index];
                            final values = [
                              Text(order.name),
                              Text(order.price.toString()),
                              Text(order.count.toString()),
                              Text(order.tableNumber?.toString() ?? "_"),
                              Text(order.createdAt),
                              MainActionButton(
                                padding: AppConstants.paddingH16V8,
                                onPressed: () {},
                                text: order.status,
                                buttonColor: AppColors.mainColor,
                              ),
                              if (isEdit || isDelete)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isDelete)
                                      InkWell(
                                        onTap: () => onDeleteTap(order),
                                        child: const Icon(Icons.delete),
                                      ),
                                    if (isDelete) const SizedBox(width: 10),
                                    if (isEdit)
                                      InkWell(
                                        onTap: () => onEditTap(order),
                                        child: const Icon(Icons.edit_outlined),
                                      )
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
                              length: state.tableOrders.meta.totalPages,
                              selectedPage: selectedPage,
                              onSelectPageTap: onSelectPageTap,
                            ),
                          ],
                        );
                      } else if (state is TableOrdersEmpty) {
                        return Text("no_orders".tr());
                      } else if (state is TableOrdersFail) {
                        return MainErrorWidget(
                          error: state.error,
                          onTryAgainTap: onTryAgainTap,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
