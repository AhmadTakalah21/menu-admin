import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

class ItemDetailModel {
  ItemDetailModel({
    required this.label,
    this.value,
  });
  final String label;
  final String? value;
}

class ItemDetailsWidget extends StatelessWidget {
  const ItemDetailsWidget({super.key, required this.item});

  final ItemModel item;

  void onIgnoreTap(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<ItemDetailModel> itemDetails = [
      ItemDetailModel(label:  "name_ar".tr(), value: item.nameAr),
      ItemDetailModel(label: "name_en".tr() , value: item.nameEn),
      ItemDetailModel(label: "description_ar".tr() , value: item.descriptionAr),
      ItemDetailModel(label: "description_en".tr() , value: item.descriptionEn),
      ItemDetailModel(label: "price".tr() , value:item.price ),
    ];
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                const Spacer(),
                Text(
                  "item_details".tr(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => onIgnoreTap(context),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.greyShade,
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            AppImageWidget(
              width: 200,
              fit: BoxFit.contain,
              url: item.image,
              errorWidget: const SizedBox(height: 200),
            ),
            const SizedBox(height: 20),
            ...itemDetails.map(
              (itemDetail) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    MainTextField(
                      labelText: itemDetail.label,
                      initialText: itemDetail.value,
                      readOnly: true,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
