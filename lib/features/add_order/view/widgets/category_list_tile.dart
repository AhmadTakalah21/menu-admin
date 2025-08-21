import 'package:flutter/material.dart';
import 'package:user_admin/features/add_order/view/widgets/item_list_tile.dart';
import 'package:user_admin/features/add_order/view/widgets/sub_category_list_tile.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';

import '../../../../global/model/restaurant_model/restaurant_model.dart';

class CategoryListTile extends StatefulWidget {
  const CategoryListTile({super.key, required this.category, required this.restaurant});
  final CategoryModel category;
  final RestaurantModel restaurant;


  @override
  State<CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {

  bool isShowSub = false;
  void _toggle() => setState(() => isShowSub = !isShowSub);

  Color _on(Color c) => c.computeLuminance() > .55 ? Colors.black87 : Colors.white;

  @override
  Widget build(BuildContext context) {
    final Color brand = widget.restaurant.color;
    final subCategories = widget.category.subCategories;
    final items = widget.category.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: _toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isShowSub ? brand : const Color(0xFFE6E8E6),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.10),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Container(
                    width: 96,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.20),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AppImageWidget(
                      url: widget.category.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        widget.category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isShowSub ? _on(brand) : AppColors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 16.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // السهم
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isShowSub
                          ? Colors.white.withOpacity(.18)
                          : brand.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isShowSub ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: isShowSub ? _on(brand) : brand,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // المحتوى عند الفتح
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 240),
          sizeCurve: Curves.easeOut,
          crossFadeState:
          isShowSub ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8, top: 6, bottom: 6),
            child: Column(
              children: [
                ...List.generate(
                  subCategories.length,
                      (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SubCategoryListTile(category: subCategories[i], restaurant: widget.restaurant,),
                  ),
                ),
                if (items.isNotEmpty) const SizedBox(height: 4),
                ...List.generate(
                  items.length,
                      (i) {
                    final item = items[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ItemListTile(
                        key: ValueKey(
                          '${item.id}_'
                              '${item.sizesTypes.map((s) => s.id).join("-")}_'
                              '${item.itemTypes.map((t) => t.id).join("-")}_'
                              '${item.componentsTypes.map((c) => c.id).join("-")}',
                        ),
                        item: item, restaurant: widget.restaurant,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
