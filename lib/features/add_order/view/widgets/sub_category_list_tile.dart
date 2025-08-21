import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_admin/features/add_order/view/widgets/item_list_tile.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';

import '../../../../global/model/restaurant_model/restaurant_model.dart';

class SubCategoryListTile extends StatefulWidget {
  const SubCategoryListTile({super.key, required this.category, required this.restaurant});
  final CategoryModel category;
  final RestaurantModel restaurant;


  @override
  State<SubCategoryListTile> createState() => _SubCategoryListTileState();
}

class _SubCategoryListTileState extends State<SubCategoryListTile> {
  bool isShowSub = false;
  void _toggle() => setState(() => isShowSub = !isShowSub);

  Color _on(Color c) => c.computeLuminance() > .55 ? Colors.black87 : Colors.white;

  @override
  Widget build(BuildContext context) {
    final Color brand = Theme.of(context).primaryColor;
    final items = widget.category.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // كبسولة فرعية أنيقة (الصورة داخل نفس الإطار)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: _toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isShowSub ? brand.withOpacity(.20) : const Color(0xFFF0F2EF),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  // معاينة الصورة داخل الكبسولة
                  Container(
                    width: 82,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AppImageWidget(
                      url: widget.category.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // عنوان التصنيف الفرعي
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        widget.category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // سهم التوسيع داخل فقاعة صغيرة
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isShowSub ? brand.withOpacity(.18) : brand.withOpacity(.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isShowSub ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: brand,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // العناصر التابعة عند الفتح
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeOut,
          crossFadeState:
          isShowSub ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8, top: 6, bottom: 6),
            child: Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ItemListTile(item: item, restaurant: widget.restaurant),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
