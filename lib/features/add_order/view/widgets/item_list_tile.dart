import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/add_order/cubit/add_order_cubit.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

class ItemListTile extends StatefulWidget {
  const ItemListTile({
    super.key,
    required this.item,
  });

  final ItemModel item;

  @override
  State<ItemListTile> createState() => _ItemListTileState();
}

class _ItemListTileState extends State<ItemListTile> {
  late final AddOrderCubit addOrderCubit = context.read();
  void onTap() {
    setState(() {
      addOrderCubit.addToCart(widget.item);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    MainSnackBar.showSuccessMessage(context, "add_to_cart_success".tr());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppConstants.paddingB10,
          child: Container(
            padding: AppConstants.padding12,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppConstants.borderRadius10,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: AppImageWidget(
                width: 50,
                height: 50,
                url: widget.item.image,
                borderRadius: AppConstants.borderRadiusCircle,
              ),
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 85,
                        child: Center(
                          child: AutoSizeText(
                            widget.item.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 85,
                        child: AutoSizeText(
                          widget.item.price,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: InkWell(
                onTap: onTap,
                child: const Icon(
                  Icons.add_shopping_cart,
                  color: AppColors.green,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
