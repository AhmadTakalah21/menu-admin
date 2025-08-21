import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/users/cubit/users_cubit.dart';
import 'package:user_admin/features/users/model/user_model/user_model.dart';
import 'package:user_admin/features/users/view/user_invoices_view.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/more_options_widget.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';
import 'package:user_admin/global/widgets/switch_view_button.dart';

import '../../../global/widgets/main_show_details_widget.dart';

abstract class UsersViewCallBacks {
  Future<void> onRefresh();
  //void onEditTap(UserModel user);
  void onDeleteTap(UserModel user);
  void onSaveDeleteTap(UserModel user);
  void onSaveActivateTap(UserModel user);
  void onActivateTap(UserModel user);
  void onShowUserInvoices(UserModel user);
  void onShowDetails(UserModel user);
  void onSelectPageTap(int page);
  void onMoreOptionsTap(UserModel user);
  void onSwichViewTap();
  void onTryAgainTap();
}

class UsersView extends StatelessWidget {
  const UsersView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return UsersPage(permissions: permissions, restaurant: restaurant);
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> implements UsersViewCallBacks {
  late final UsersCubit usersCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();
  int selectedPage = 1;

  bool isCardView = true;

  @override
  void initState() {
    super.initState();
    usersCubit.getUsers(1);
  }

  // @override
  // void onEditTap(UserModel user) {
  //   _showDialog(EditUserWidget(user: user, restaurant: widget.restaurant));
  // }

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
  void onShowDetails(UserModel user) {
    final String activity = user.isActive ? "active".tr() : "inactive".tr();

    final details = _UserDetails(
      id: user.id,
      image: (user.image?.isNotEmpty ?? false) ? user.image : null,
      tiles: [
        IconTitleValueModel(icon: Icons.person,        title: 'name',         value: user.name),
        IconTitleValueModel(icon: Icons.badge,         title: 'account_name', value: user.username),
        IconTitleValueModel(icon: Icons.phone,         title: 'phone_number', value: user.phone),
        IconTitleValueModel(icon: Icons.home,          title: 'address',      value: user.address ?? '---'),
        IconTitleValueModel(icon: Icons.cake,          title: 'birthday',     value: user.birthday ?? '---'),
        IconTitleValueModel(icon: Icons.verified_user, title: 'status',       value: activity),
      ],
    );

    showDialog(
      context: context,
      builder: (_) => MainShowDetailsWidget<_UserDetails>(
        model: details,
        iconOnImage: (details.image != null)
            ? const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.black54,
          child: Icon(Icons.zoom_in, color: Colors.white, size: 16),
        )
            : null,
        onIconOnImageTap: (ctx, m) {
          Navigator.of(ctx).pop();
        },
      ),
    );
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
        builder: (context) => UserInvoicesView(
          restaurant: widget.restaurant,
          permissions: widget.permissions,
          user: user,
        ),
      ),
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
    return widget.permissions.any(
          (element) => element.name == permission,
    );
  }

  @override
  void onSwichViewTap() {
    setState(() {
      isCardView = !isCardView;
    });
  }

  @override
  void onMoreOptionsTap(UserModel user) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return MoreOptionsWidget(
          item: user,
          onShowDetailsTap: onShowDetails,
          // onEditTap: onEditTap,
          onDeleteTap: onDeleteTap,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState && state.item is UserModel) {
          onTryAgainTap();
        }
      },
      child: Scaffold(
        appBar: MainAppBar(restaurant: widget.restaurant,
            title: "users".tr(),
          onSearchChanged: (q) => usersCubit.searchByName(q),
          onSearchSubmitted: (q) => usersCubit.searchByName(q),
          onSearchClosed: () => usersCubit.searchByName(''),
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
                  // MainBackButton(color: restaurantColor),
                  // const SizedBox(height: 20),
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SwitchViewButton(
              onTap: onSwichViewTap,
              isCardView: isCardView,
              color: widget.restaurant.color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(GeneralUsersState state) {
    if (state is UsersLoading) {
      return const LoadingIndicator(color: AppColors.black);
    } else if (state is UsersSuccess) {
      if (isCardView) {
        return _buildCardView(state);
      } else {
        return _buildTableView(state);
      }
    } else if (state is UsersEmpty) {
      return Center(child: Text(state.message));
    } else if (state is UsersFail) {
      return Center(
        child: MainErrorWidget(
          error: state.error,
          onTryAgainTap: onTryAgainTap,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCardView(UsersSuccess state) {
    bool isEdit = hasPermission("user.update");
    bool isDelete = hasPermission("user.delete");
    bool isActive = hasPermission("user.active");
    bool isOrder = hasPermission("order.index");

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: state.paginatedModel.data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final user = state.paginatedModel.data[index];
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
                          user.name,
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
                      if (isOrder)
                        InkWell(
                          onTap: () => onShowUserInvoices(user),
                          child: const Icon(
                            FontAwesomeIcons.fileInvoice,
                            color: AppColors.white,
                          ),
                        ),
                      const SizedBox(width: 4),
                      if (isActive)
                        InkWell(
                          onTap: () => onActivateTap(user),
                          child: Icon(
                            user.isActive ? Icons.block : Icons.check_circle,
                            color: AppColors.white,
                          ),
                        ),
                      if (!isEdit && !isDelete)
                        InkWell(
                          onTap: () => onShowDetails(user),
                          child: const Icon(
                            Icons.visibility_outlined,
                            color: AppColors.white,
                          ),
                        ),
                      if (isEdit && isDelete)
                        InkWell(
                          onTap: () => onMoreOptionsTap(user),
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
                          textWidget(
                              "${"account_name".tr()} : ${user.username}"),
                          textWidget("${"phone_number".tr()} : ${user.phone}"),
                          textWidget(
                              "${"address".tr()} : ${user.address ?? '---'}"),
                          textWidget(
                              "${"birthday".tr()} : ${user.birthday ?? "---"}"),
                          textWidget(
                              "${"status".tr()} : ${user.status ?? "---"}"),
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

  Widget _buildTableView(UsersSuccess state) {
    final List<String> titles = [
      "name".tr(),
      "account_name".tr(),
      "phone_number".tr(),
      "address".tr(),
      "birthday".tr(),
      "status".tr(),
    ];

    bool isEdit = hasPermission("user.update");
    bool isDelete = hasPermission("user.delete");
    bool isActive = hasPermission("user.active");
    bool isOrder = hasPermission("order.index");

    if (isEdit || isDelete || isActive || isOrder) {
      titles.add("event".tr());
    }
    List<DataRow> rows = state.paginatedModel.data.map((user) {
      return DataRow(cells: _buildUserCells(user));
    }).toList();

    return Column(
      children: [
        MainDataTable(
          titles: titles,
          rows: rows,
          color: widget.restaurant.color,
        ),
        SelectPageTile(
          length: state.paginatedModel.meta.totalPages,
          selectedPage: selectedPage,
          onSelectPageTap: onSelectPageTap,
        ),
      ],
    );
  }

  List<DataCell> _buildUserCells(UserModel user) {
    bool isEdit = hasPermission("user.update");
    bool isDelete = hasPermission("user.delete");
    bool isActive = hasPermission("user.active");
    bool isOrder = hasPermission("order.index");
    final activityStatus = user.isActive ? "active".tr() : "inactive".tr();

    return [
      DataCell(Center(child: Text(user.name))),
      DataCell(Center(child: Text(user.username))),
      DataCell(Center(child: Text(user.phone))),
      DataCell(Center(child: Text(user.address ?? "_"))),
      DataCell(Center(child: Text(user.birthday ?? "_"))),
      DataCell(Center(child: Text(activityStatus))),
      if (isEdit || isDelete || isActive || isOrder)
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOrder)
                InkWell(
                  onTap: () => onShowUserInvoices(user),
                  child: const Icon(FontAwesomeIcons.fileInvoice),
                ),
              if (isOrder) const SizedBox(width: 10),
              if (isDelete)
                InkWell(
                  onTap: () => onDeleteTap(user),
                  child: const Icon(Icons.delete),
                ),
              if (isDelete) const SizedBox(width: 10),
              // if (isEdit)
              //   InkWell(
              //     onTap: () => onEditTap(user),
              //     child: const Icon(Icons.edit_outlined),
              //   ),
              // if (isEdit) const SizedBox(width: 10),
              if (isActive)
                InkWell(
                  onTap: () => onActivateTap(user),
                  child: Icon(
                    user.isActive ? Icons.block : Icons.check_circle,
                    size: 30,
                  ),
                ),
            ],
          ),
        )
    ];
  }
}

class _UserDetails implements DetailsModel {
  @override
  final int id;
  @override
  final String? image;
  @override
  final List<IconTitleValueModel> tiles;

  const _UserDetails({
    required this.id,
    this.image,
    required this.tiles,
  });
}
