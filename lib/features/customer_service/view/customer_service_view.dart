import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/customer_service/cubit/customer_service_cubit.dart';
import 'package:user_admin/features/customer_service/model/service_model/service_model.dart';
import 'package:user_admin/features/customer_service/view/widgets/add_service_widget.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_add_button.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
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
        restaurant: widget.restaurant,
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
        restaurant: widget.restaurant,
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
    bool isAdd = widget.permissions.any((e) => e.name == "service.add");
    final restColor = widget.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState) {
          customerServiceCubit.getServices(page: selectedPage);
        }
      },
      child: Scaffold(
          appBar: MainAppBar(
            restaurant: widget.restaurant,
            title: "services".tr(),
            onSearchChanged: (q) => customerServiceCubit.searchByName(q),
            onSearchSubmitted: (q) => customerServiceCubit.searchByName(q),
            onSearchClosed: () => customerServiceCubit.searchByName(''),
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
                  children: [
                    BlocBuilder<CustomerServiceCubit, GeneralCustomerService>(
                      buildWhen: (previous, current) =>
                      current is CustomerServiceState,
                      builder: (context, state) {
                        if (state is CustomerServiceLoading) {
                          return const LoadingIndicator(color: AppColors.black);
                        } else if (state is CustomerServiceSuccess) {
                          return _buildTableView(state.services);
                        } else if (state is CustomerServiceEmpty) {
                          return MainErrorWidget(
                            error: "no_services".tr(),
                            isRefresh: true,
                            buttonColor: widget.restaurant.color,
                            onTryAgainTap: onTryAgainTap,
                          );
                        } else if (state is CustomerServiceFail) {
                          return MainErrorWidget(
                            error: state.error,
                            buttonColor: widget.restaurant.color,
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
          floatingActionButton:
          isAdd ? MainAddButton(onTap: onAddTap, color: restColor) : null),
    );
  }

  Widget _buildTableView(PaginatedModel<ServiceModel> services) {
    final List<String> titles = [
      "service".tr(),
      "price".tr(),
    ];

    bool isEdit = widget.permissions.any((e) => e.name == "service.update");
    bool isDelete = widget.permissions.any((e) => e.name == "service.delete");

    if (isEdit || isDelete) {
      titles.add("event".tr());
    }

    List<DataRow> rows = [];
    rows = List.generate(
      services.data.length,
          (index) {
        final order = services.data[index];
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
              return DataCell(Center(child: values[index2]));
            },
          ),
        );
      },
    );
    return Column(
      children: [
        MainDataTable(
          titles: titles,
          rows: rows,
          color: widget.restaurant.color,
        ),
        SelectPageTile(
          length: services.meta.totalPages,
          selectedPage: selectedPage,
          onSelectPageTap: onSelectPageTap,
        ),
      ],
    );
  }
}
