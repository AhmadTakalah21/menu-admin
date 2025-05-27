import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/tables/view/table_orders_view.dart';
import 'package:user_admin/features/tables/view/widgets/edit_table_widget.dart';
import 'package:user_admin/features/tables/view/widgets/table_details_widget.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

import '../cubit/tables_cubit.dart';

abstract class TablesViewCallBacks {
  void onAddTableTap();

  Future<void> onRefresh();

  void onEditTap(TableModel table);

  void onDeleteTap(TableModel table);

  void onSaveDeleteTap(TableModel table);

  void onShowDetails(TableModel table);

  void onShowTableOrders(TableModel table);

  void onSelectPageTap(int page);

  void onTryAgainTap();
}

class TablesView extends StatelessWidget {
  const TablesView({
    super.key,
    required this.signInModel,
  });

  final SignInModel signInModel;

  @override
  Widget build(BuildContext context) {
    return TablesPage(signInModel: signInModel);
  }
}

class TablesPage extends StatefulWidget {
  const TablesPage({
    super.key,
    required this.signInModel,
  });

  final SignInModel signInModel;

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage>
    implements TablesViewCallBacks {
  late final TablesCubit tablesCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    tablesCubit.getTables(page: selectedPage);
  }

  @override
  void onAddTableTap() {
    showDialog(
      context: context,
      builder: (context) {
        return const EditTableWidget(isEdit: false);
      },
    );
  }

  @override
  void onShowDetails(TableModel table) {
    showDialog(
      context: context,
      builder: (context) {
        return TableDetailsWidget(
          qrCode: table.qrCode ?? "",
          title: table.tableNumber.toString(),
        );
      },
    );
  }

  @override
  void onShowTableOrders(TableModel table) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TableOrdersView(
          signInModel: widget.signInModel,
          table: table,
        ),
      ),
    );
  }

  @override
  void onDeleteTap(TableModel table) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: true,
          item: table,
          onSaveTap: onSaveDeleteTap,
        );
      },
    );
  }

  @override
  void onEditTap(TableModel table) {
    showDialog(
      context: context,
      builder: (context) {
        return EditTableWidget(
          table: table,
          isEdit: true,
        );
      },
    );
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      tablesCubit.getTables(page: page);
    }
  }

  @override
  Future<void> onRefresh() async {
    tablesCubit.getTables();
  }

  @override
  void onTryAgainTap() {
    tablesCubit.getTables(page: selectedPage);
  }

  @override
  void onSaveDeleteTap(TableModel table) {
    deleteCubit.deleteItem<TableModel>(table);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "table_num".tr(),
      "event".tr(),
    ];

    int addIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "table.add",
    );
    int editIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "table.update",
    );
    int deleteIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "table.delete",
    );
    int orderIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "order.index",
    );
    bool isAdd = addIndex != -1;
    bool isEdit = editIndex != -1;
    bool isDelete = deleteIndex != -1;
    bool isOrder = orderIndex != -1;

    final restColor = widget.signInModel.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState) {
          tablesCubit.getTables(page: selectedPage);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        drawer: MainDrawer(signInModel: widget.signInModel),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: AppConstants.padding16,
              child: Column(
                children: [
                  MainBackButton(color: restColor ?? AppColors.black),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "tables".tr(),
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
                        child:
                            const Icon(Icons.refresh, color: AppColors.white),
                      ),
                      if (isAdd) const SizedBox(width: 10),
                      if (isAdd)
                        MainActionButton(
                          padding: AppConstants.padding10,
                          onPressed: onAddTableTap,
                          text: "Add table",
                          child: const Icon(
                            Icons.add_circle,
                            color: AppColors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<TablesCubit, GeneralTablesState>(
                    buildWhen: (previous, current) => current is TablesStates,
                    builder: (context, state) {
                      if (state is TablesLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is TablesSuccess) {
                        List<DataRow> rows = [];
                        rows = List.generate(
                          state.tables.data.length,
                          (index) {
                            final table = state.tables.data[index];
                            final color = table.tableStatus == 1
                                ? AppColors.red
                                : table.tableStatus == 2
                                    ? AppColors.yellow
                                    : AppColors.green;
                            final values = [
                              Container(
                                padding: AppConstants.padding6,
                                decoration: BoxDecoration(
                                  borderRadius: AppConstants.borderRadius5,
                                  color: color,
                                ),
                                child: Text(table.tableNumber.toString()),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isEdit)
                                    InkWell(
                                      onTap: () => onEditTap(table),
                                      child: const Icon(Icons.edit_outlined),
                                    ),
                                  if (isEdit) const SizedBox(width: 10),
                                  if (isDelete)
                                    InkWell(
                                      onTap: () => onDeleteTap(table),
                                      child: const Icon(Icons.delete),
                                    ),
                                  if (isDelete) const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () => onShowDetails(table),
                                    child: const Icon(Icons.remove_red_eye),
                                  ),
                                  const SizedBox(width: 10),
                                  if (isOrder)
                                    InkWell(
                                      onTap: () => onShowTableOrders(table),
                                      child: const Icon(Icons.shopping_cart),
                                    ),
                                  if (isOrder) const SizedBox(width: 10),
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
                              length: state.tables.meta.totalPages,
                              selectedPage: selectedPage,
                              onSelectPageTap: onSelectPageTap,
                            ),
                          ],
                        );
                      } else if (state is TablesEmpty) {
                        return MainErrorWidget(error: state.message);
                      } else if (state is TablesFail) {
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
