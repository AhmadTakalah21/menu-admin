import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/users/cubit/users_cubit.dart';
import 'package:user_admin/features/users/model/user_model/user_model.dart';
import 'package:user_admin/features/users/view/user_invoices_view.dart';
import 'package:user_admin/features/users/view/widgets/add_user_widget.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
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

abstract class UsersViewCallBacks {
  Future<void> onRefresh();
  void onEditTap(UserModel user);
  void onDeleteTap(UserModel user);
  void onSaveDeleteTap(UserModel user);
  void onSaveActivateTap(UserModel user);
  void onActivateTap(UserModel user);
  void onShowUserInvoices(UserModel user);
  void onSelectPageTap(int page);
  void onTryAgainTap();
}

class UsersView extends StatelessWidget {
  const UsersView({
    super.key,
    required this.signInModel,
  });

  final SignInModel signInModel;

  @override
  Widget build(BuildContext context) {
    return UsersPage(signInModel: signInModel);
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({
    super.key,
    required this.signInModel,
  });

  final SignInModel signInModel;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> implements UsersViewCallBacks {
  late final UsersCubit usersCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();
  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    usersCubit.getUsers(1);
  }

  @override
  void onEditTap(UserModel user) {
    _showDialog(EditUserWidget(user: user, signInModel: widget.signInModel));
  }

  @override
  void onActivateTap(UserModel user) {
    _showDialog(InsureDeleteWidget(
        isDelete: false, item: user, onSaveTap: onSaveActivateTap));
  }

  @override
  void onDeleteTap(UserModel user) {
    _showDialog(InsureDeleteWidget(
        isDelete: true, item: user, onSaveTap: onSaveDeleteTap));
  }

  @override
  void onSaveActivateTap(UserModel user) {
    deleteCubit.deactivateItem<UserModel>(user);
  }

  @override
  void onSaveDeleteTap(UserModel user) {
    deleteCubit.deleteItem<UserModel>(user);
  }

  @override
  void onShowUserInvoices(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              UserInvoicesView(signInModel: widget.signInModel, user: user)),
    );
  }

  @override
  Future<void> onRefresh() async {
    usersCubit.getUsers(1);
    setState(() {
      selectedPage = 1;
    });
  }

  @override
  void onTryAgainTap() {
    usersCubit.getUsers(1);
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
      usersCubit.getUsers(page);
    }
  }

  void _showDialog(Widget dialog) {
    showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  bool hasPermission(String permission) {
    return widget.signInModel.permissions.any(
      (element) => element.name == permission,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "name".tr(),
      "account_name".tr(),
      "phone_number".tr(),
      "address".tr(),
      "birthday".tr(),
      "status".tr(),
    ];

    _addActionColumns(titles);

    final restaurantColor = widget.signInModel.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState && state.item is UserModel) {
          onTryAgainTap();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainBackButton(color: restaurantColor ?? AppColors.black),
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  BlocBuilder<UsersCubit, GeneralUsersState>(
                    buildWhen: (previous, current) => current is UsersState,
                    builder: (context, state) {
                      return _buildUserList(state);
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

  Row _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("users".tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        MainActionButton(
          padding: AppConstants.padding8,
          onPressed: onRefresh,
          text: "",
          child: const Icon(Icons.refresh, color: AppColors.white),
        ),
      ],
    );
  }

  void _addActionColumns(List<String> titles) {
    bool isEdit = hasPermission("user.update");
    bool isDelete = hasPermission("user.delete");
    bool isActive = hasPermission("user.active");
    bool isOrder = hasPermission("order.index");

    if (isEdit || isDelete || isActive || isOrder) {
      titles.add("event".tr());
    }
  }

  Widget _buildUserList(GeneralUsersState state) {
    if (state is UsersLoading) {
      return const LoadingIndicator(color: AppColors.black);
    } else if (state is UsersSuccess) {
      return _buildUsersSuccess(state);
    } else if (state is UsersEmpty) {
      return Center(child: Text(state.message));
    } else if (state is UsersFail) {
      return Center(
          child: MainErrorWidget(
              error: state.error, onTryAgainTap: onTryAgainTap));
    } else {
      return const SizedBox.shrink();
    }
  }

  Column _buildUsersSuccess(UsersSuccess state) {
    List<DataRow> rows = state.paginatedModel.data.map((user) {
      return DataRow(cells: _buildUserCells(user));
    }).toList();

    return Column(
      children: [
        MainDataTable(titles: [
          "name".tr(),
          "account_name".tr(),
          "phone_number".tr(),
          "address".tr(),
          "birthday".tr(),
          "status".tr(),
        ], rows: rows),
        SelectPageTile(
          length: state.paginatedModel.meta.totalPages,
          selectedPage: selectedPage,
          onSelectPageTap: onSelectPageTap,
        ),
      ],
    );
  }

  List<DataCell> _buildUserCells(UserModel user) {
    return [
      DataCell(Center(child: Text(user.name))),
      DataCell(Center(child: Text(user.username))),
      DataCell(Center(child: Text(user.phone))),
      DataCell(Center(child: Text(user.address ?? "_"))),
      DataCell(Center(child: Text(user.birthday ?? "_"))),
      DataCell(
        Center(
          child: MainActionButton(
            padding: AppConstants.padding6,
            onPressed: () {},
            text: user.isActive ? "active".tr() : "inactive".tr(),
            buttonColor: user.isActive ? AppColors.greenShade : AppColors.red,
          ),
        ),
      ),
    ];
  }
}
