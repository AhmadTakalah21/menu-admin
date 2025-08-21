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
import '../../../global/widgets/main_app_bar.dart';

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
    final brand = widget.restaurant.color ?? AppColors.mainColor;

    return Scaffold(
      appBar: MainAppBar(
        restaurant: widget.restaurant,
        title: "add_order".tr(),
        onSearchChanged: (q) => addOrderCubit.searchByName(q),
        onSearchSubmitted: (q) => addOrderCubit.searchByName(q),
        onSearchClosed: () => addOrderCubit.searchByName(''),
        onLanguageToggle: (loc) {
        },
      ),
      drawer: MainDrawer(
        permissions: widget.permissions,
        restaurant: widget.restaurant,
      ),

      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: AppConstants.padding16,
                child: Column(
                  children: [
                    BlocBuilder<AddOrderCubit, GeneralAddOrderState>(
                      buildWhen: (p, c) => c is CategoriesSubsItemsState,
                      builder: (context, state) {
                        if (state is CategoriesSubsItemsLoading) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: LoadingIndicator(color: AppColors.black),
                          );
                        } else if (state is CategoriesSubsItemsSuccess) {
                          return Column(
                            children: List.generate(
                              state.categories.length,
                                  (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: CategoryListTile(category: state.categories[index], restaurant:widget.restaurant,),
                              ),
                            ),
                          );
                        } else if (state is CategoriesSubsItemsEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(state.message),
                          );
                        } else if (state is CategoriesSubsItemsFail) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 30),
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

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: BlocBuilder<AddOrderCubit, GeneralAddOrderState>(
        buildWhen: (p, c) => c is CartState,
        builder: (context, state) {
          final count = addOrderCubit.cartItems.length;
          return _FloatingCartButton(
            brand: brand,
            count: count,
            onTap: onShowCartTap,
          );
        },
      ),
    );
  }
}

class _FloatingCartButton extends StatelessWidget {
  const _FloatingCartButton({
    required this.brand,
    required this.count,
    required this.onTap,
  });

  final Color brand;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            heroTag: 'fab-cart',
            backgroundColor: brand,
            elevation: 8,
            onPressed: onTap,
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
          if (count > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.18),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

