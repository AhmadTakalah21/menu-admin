import 'package:flutter/material.dart';
import 'package:user_admin/features/add_order/view/widgets/item_list_tile.dart';
import 'package:user_admin/features/add_order/view/widgets/sub_category_list_tile.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';

class CategoryListTile extends StatefulWidget {
  const CategoryListTile({
    super.key,
    required this.category,
  });

  final CategoryModel category;

  @override
  State<CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  void onTap() {
    setState(() {
      isShowSub = !isShowSub;
    });
  }

  bool isShowSub = false;
  @override
  Widget build(BuildContext context) {
    final subCategories = widget.category.subCategories;
    final items = widget.category.items;
    return Column(
      children: [
        Padding(
          padding: AppConstants.paddingB10,
          child: InkWell(
            onTap: onTap,
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
                  url: widget.category.image,
                  borderRadius: AppConstants.borderRadiusCircle,
                ),
                title: Text(
                  widget.category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(
                  isShowSub ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        if (isShowSub)
          Padding(
            padding: AppConstants.padding16,
            child: Column(
              children: [
                ...List.generate(
                  subCategories.length,
                  (index) {
                    final subCategory = subCategories[index];
                    return SubCategoryListTile(category: subCategory);
                  },
                ),
                if(items.isNotEmpty)
                ...List.generate(
                  items.length,
                  (index) {
                    final item = items[index];
                    return ItemListTile(
                      key: ValueKey('${item.id}_${item.sizesTypes.map((s) => s.id).join("-")}_${item.itemTypes.map((t) => t.id).join("-")}_${item.componentsTypes.map((c) => c.id).join("-")}'),
                      item: item,
                    );

                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
