import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/customer_service/cubit/customer_service_cubit.dart';
import 'package:user_admin/features/customer_service/model/service_model/service_model.dart';
import 'package:user_admin/features/customer_service/view/widgets/add_service_widget.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
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

abstract class CustomerServiceViewCallBacks {
  void onAddTap();

  void onEditTap(ServiceModel service);

  void onDeleteTap(ServiceModel service);

  void onSaveDeleteTap(ServiceModel service);

  void onSelectPageTap(int page);

  Future<void> onRefresh();

  void onTryAgainTap();
}

class CustomerServiceView extends StatelessWidget {
  const CustomerServiceView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return CustomerServicePage(
      permissions: permissions,
      restaurant: restaurant,
    );
  }
}

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<CustomerServicePage> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage>
    implements CustomerServiceViewCallBacks {
  late final CustomerServiceCubit customerServiceCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    customerServiceCubit.getServices(page: selectedPage);
  }

  @override
  void onAddTap() {
    showDialog(
      context: context,
      builder: (context) => AddServiceWidget(
        isEdit: false,
        selectedPage: selectedPage,
      ),
    );
  }

  @override
  void onDeleteTap(ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: true,
          item: service,
          onSaveTap: onSaveDeleteTap,
        );
      },
    );
  }

  @override
  void onSaveDeleteTap(ServiceModel service) {
    deleteCubit.deleteItem<ServiceModel>(service);
  }

  @override
  void onEditTap(ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) => AddServiceWidget(
        isEdit: true,
        service: service,
        selectedPage: selectedPage,
      ),
    );
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      customerServiceCubit.getServices(page: page);
    }
  }

  @override
  Future<void> onRefresh() async {
    customerServiceCubit.getServices();
  }

  @override
  void onTryAgainTap() {
    customerServiceCubit.getServices(page: selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "service".tr(),
      "price".tr(),
    ];
    int addIndex = widget.permissions.indexWhere(
      (element) => element.name == "service.add",
    );
    int editIndex = widget.permissions.indexWhere(
      (element) => element.name == "service.update",
    );
    int deleteIndex = widget.permissions.indexWhere(
      (element) => element.name == "service.delete",
    );
    bool isAdd = addIndex != -1;
    bool isEdit = editIndex != -1;
    bool isDelete = deleteIndex != -1;

    if (isEdit || isDelete) {
      titles.add("event".tr());
    }

    final restColor = widget.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState) {
          customerServiceCubit.getServices(page: selectedPage);
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
                  MainBackButton(color: restColor!),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "services".tr(),
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
                          onPressed: onAddTap,
                          text: "add_order".tr(),
                          child: const Icon(
                            Icons.add_circle,
                            color: AppColors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<CustomerServiceCubit, GeneralCustomerService>(
                    buildWhen: (previous, current) =>
                        current is CustomerServiceState,
                    builder: (context, state) {
                      List<DataRow> rows = [];
                      if (state is CustomerServiceLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is CustomerServiceSuccess) {
                        rows = List.generate(
                          state.services.data.length,
                          (index) {
                            final order = state.services.data[index];
                            final values = [
                              Text(order.name),
                              Text(order.price.toString()),
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
                              length: state.services.meta.totalPages,
                              selectedPage: selectedPage,
                              onSelectPageTap: onSelectPageTap,
                            ),
                          ],
                        );
                      } else if (state is CustomerServiceEmpty) {
                        return Text("no_orders".tr());
                      } else if (state is CustomerServiceFail) {
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
