import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/add_order/cubit/add_order_cubit.dart';
import 'package:user_admin/features/add_order/view/cart_view.dart';
import 'package:user_admin/features/add_order/view/widgets/category_list_tile.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';

abstract class AddOrderViewCallBacks {
  Future<void> onRefresh();
  void onShowCartTap();
  void onTryAgainTap();
}

class AddOrderView extends StatelessWidget {
  const AddOrderView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return AddOrderPage(permissions: permissions, restaurant: restaurant);
  }
}

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage>
    implements AddOrderViewCallBacks {
  late final AddOrderCubit addOrderCubit = context.read();
  late final ItemsCubit itemsCubit = context.read();

  @override
  void initState() {
    addOrderCubit.getCategories(widget.restaurant.id);
    itemsCubit.getTables();
    super.initState();
  }

  @override
  void onShowCartTap() {
    showDialog(
      context: context,
      builder: (context) {
        return CartView(
          permissions: widget.permissions,
          restaurant: widget.restaurant,
        );
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    addOrderCubit.getCategories(widget.restaurant.id);
    itemsCubit.getTables();
  }

  @override
  void onTryAgainTap() {
    addOrderCubit.getCategories(widget.restaurant.id);
    itemsCubit.getTables();
  }

  @override
  Widget build(BuildContext context) {
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
              children: [
                Row(
                  children: [
                    MainBackButton(color: restColor!),
                    const Spacer(),
                    BlocBuilder<AddOrderCubit, GeneralAddOrderState>(
                      buildWhen: (previous, current) => current is CartState,
                      builder: (context, state) {
                        final cartLength = addOrderCubit.cartItems.length;
                        return InkWell(
                          onTap: onShowCartTap,
                          child: Badge(
                            backgroundColor: AppColors.red,
                            textColor: AppColors.black,
                            padding: AppConstants.padding2,
                            label: Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Text(cartLength.toString()),
                            ),
                            child: const Icon(Icons.shopping_cart, size: 30),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "categories".tr(),
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
                      child: const Icon(Icons.refresh, color: AppColors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<AddOrderCubit, GeneralAddOrderState>(
                  buildWhen: (previous, current) =>
                      current is CategoriesSubsItemsState,
                  builder: (context, state) {
                    if (state is CategoriesSubsItemsLoading) {
                      return const LoadingIndicator(color: AppColors.black);
                    } else if (state is CategoriesSubsItemsSuccess) {
                      return Column(
                        children: List.generate(
                          state.categories.length,
                          (index) {
                            final category = state.categories[index];
                            return CategoryListTile(category: category);
                          },
                        ),
                      );
                    } else if (state is CategoriesSubsItemsEmpty) {
                      return Text(state.message);
                    } else if (state is CategoriesSubsItemsFail) {
                      return MainErrorWidget(
                        error: state.error,
                        onTryAgainTap: onTryAgainTap,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
