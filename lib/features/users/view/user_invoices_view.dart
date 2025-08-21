import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/users/cubit/users_cubit.dart';
import 'package:user_admin/features/users/model/user_model/user_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/invoice_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

abstract class UserInvoicesViewCallBacks {
  Future<void> onRefresh();
  void onShowInvoice(DrvierInvoiceModel invoice);
  void onSelectPageTap(int page);
  void onTryAgainTap();
}

class UserInvoicesView extends StatelessWidget {
  const UserInvoicesView({
    super.key,
    required this.user,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return UserInvoicesPage(
      user: user,
      permissions: permissions,
      restaurant: restaurant,
    );
  }
}

class UserInvoicesPage extends StatefulWidget {
  const UserInvoicesPage({
    super.key,
    required this.user,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;
  final UserModel user;

  @override
  State<UserInvoicesPage> createState() => _UserInvoicesPageState();
}

class _UserInvoicesPageState extends State<UserInvoicesPage>
    implements UserInvoicesViewCallBacks {
  late final UsersCubit usersCubit = context.read();
  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    _loadUserInvoices();
  }

  void _loadUserInvoices() {
    usersCubit.getUserInvoices(widget.user.id, selectedPage);
  }

  @override
  void onShowInvoice(DrvierInvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (context) => InvoiceWidget(invoice: invoice),
    );
  }

  @override
  Future<void> onRefresh() async {
    _loadUserInvoices();
    setState(() {
      selectedPage = 1;
    });
  }

  @override
  void onTryAgainTap() {
    _loadUserInvoices();
    setState(() {
      selectedPage = 1;
    });
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      usersCubit.getUserInvoices(widget.user.id, page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      "invoice_num".tr(),
      "username".tr(),
      "created_at".tr(),
      "recieved_at".tr(),
      "status".tr(),
      "event".tr(),
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
                MainBackButton(color: restColor),
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 20),
                _buildInvoiceList(titles),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "user_invoices".tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        MainActionButton(
          padding: AppConstants.padding8,
          onPressed: onRefresh,
          text: "",
          child: const Icon(Icons.refresh, color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildInvoiceList(List<String> titles) {
    return BlocBuilder<UsersCubit, GeneralUsersState>(
      buildWhen: (previous, current) => current is UserInvoicesState,
      builder: (context, state) {
        if (state is UserInvoicesLoading) {
          return const LoadingIndicator(color: AppColors.black);
        } else if (state is UserInvoicesSuccess) {
          return Column(
            children: [
              MainDataTable(
                titles: titles,
                rows: _generateInvoiceRows(state.paginatedModel.data),
                color: widget.restaurant.color,
              ),
              SelectPageTile(
                length: state.paginatedModel.meta.totalPages,
                selectedPage: selectedPage,
                onSelectPageTap: onSelectPageTap,
              ),
            ],
          );
        } else if (state is UserInvoicesEmpty) {
          return Center(child: Text(state.message));
        } else if (state is UserInvoicesFail) {
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
    );
  }

  List<DataRow> _generateInvoiceRows(List<DrvierInvoiceModel> invoices) {
    return List.generate(
      invoices.length,
          (index) {
        final invoice = invoices[index];
        return DataRow(
          cells: [
            DataCell(Center(child: Text(invoice.number.toString()))),
            DataCell(Center(child: Text(invoice.user ?? "_"))),
            DataCell(Center(child: Text(invoice.createdAt))),
            DataCell(Center(child: Text(invoice.receivedAt ?? "_"))),
            DataCell(
              Center(
                child: MainActionButton(
                  padding: AppConstants.padding6,
                  onPressed: () {},
                  text: invoice.status ?? "unknown",
                  buttonColor: AppColors.mainColor,
                ),
              ),
            ),
            DataCell(
              Center(
                child: InkWell(
                  onTap: () => onShowInvoice(invoice),
                  child: const Icon(Icons.remove_red_eye),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
