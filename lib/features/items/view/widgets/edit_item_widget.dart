import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:user_admin/features/home/cubit/home_cubit.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/features/items/model/is_panorama_enum.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

import '../../../../global/widgets/edit_item_image_section.dart';
import '../../model/add_component_item_model/add_component_item_model.dart';
import '../../model/add_nutrition_item_model/add_nutrition_item_model.dart';

abstract class EditItemWidgetCallBacks {
  void onCategoryChanged(CategoryModel? category);
  void onNameArChanged(String nameAr);
  void onNameArSubmitted(String nameAr);
  void onNameEnChanged(String nameEn);
  void onNameEnSubmitted(String nameEn);
  void onPriceChanged(String price);
  void onPriceSubmitted(String price);
  void onDescriptionArChanged(String descriptionAr);
  void onDescriptionArSubmitted(String descriptionAr);
  void onDescriptionEnChanged(String descriptionEn);
  void onDescriptionEnSubmitted(String descriptionEn);
  void onIsPanoramaSelected(IsPanoramaEnum isPanoramaEnum);
  void onImageTap(int? itemId); // تعديل لتقبل itemId
  void onImage2Tap(int? itemId);
  void onAddExtraItem();
  void onNameArExtraChanged(String nameAr, int index);
  void onNameEnExtraChanged(String nameEn, int index);
  void onPriceExtraChanged(String price, int index);
  void onSetImageExtra(int index, int? itemId);
  void onRemoveExtra(int index);
  void onAddSizeItem();
  void onNameArSizeChanged(String nameAr, int index);
  void onNameEnSizeChanged(String nameEn, int index);
  void onPriceSizeChanged(String price, int index);
  void onSetImageSize(int index, int? itemId);
  void onDescriptionArSizeChanged(String desc, int index);
  void onDescriptionEnSizeChanged(String desc, int index);
  void onRemoveSize(int index);
  void onAddComponentItem();
  void onNameArComponentChanged(String nameAr, int index);
  void onNameEnComponentChanged(String nameEn, int index);
  void onIsBasicComponentChanged(bool isBasic, int index);
  void onRemoveComponent(int index);
  void onAddNutritionItem();
  void onRemoveNutritionItem();
  void onSaveTap();
  void onIgnoreTap();
}

class EditItemWidget extends StatefulWidget {
  const EditItemWidget({
    super.key,
    required this.isEdit,
    required this.category,
    this.item,
    required this.restaurant,
  });
  final ItemModel? item;
  final CategoryModel category;
  final RestaurantModel restaurant;
  final bool isEdit;

  @override
  State<EditItemWidget> createState() => _EditItemWidgetState();
}

class _EditItemWidgetState extends State<EditItemWidget>
    implements EditItemWidgetCallBacks {
  late final ItemsCubit itemsCubit = context.read();
  late final HomeCubit homeCubit = context.read();

  final categoryFocusNode = FocusNode();
  final nameArFocusNode = FocusNode();
  final nameEnFocusNode = FocusNode();
  final descriptionArFocusNode = FocusNode();
  final descriptionEnFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final isPanoramaFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    homeCubit.getCategoriesSub(isRefresh: true);

    if (!widget.isEdit) {
      itemsCubit.setCategory(widget.category.id);
    }

    if (widget.isEdit && item != null) {
      final nutrition = item.nutrition;

      itemsCubit
        ..setNameAr(item.nameAr)
        ..setNameEn(item.nameEn)
        ..setDescriptionAr(item.descriptionAr)
        ..setDescriptionEn(item.descriptionEn)
        ..setIsPanorama(item.isPanorama)
        ..setCategory(item.categoryId)
        ..setPrice(item.price)
        ..setWeight(nutrition?.amount)
        ..setCalories(nutrition?.kcal)
        ..setProtein(nutrition?.protein)
        ..setFat(nutrition?.fat)
        ..setCarbs(nutrition?.carbs);

      if (nutrition?.unit != null) {
        itemsCubit.editItemModel = itemsCubit.editItemModel.copyWith(
          nutrition: AddNutritionItemModel.fromJson(nutrition!.toJson()),
        );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        itemsCubit.getExtras(item, isRemove: false);
      });

      itemsCubit.getSizes(item, isRemove: false);
      itemsCubit.getComponents(item, isRemove: false);
    } else {
      itemsCubit.clearExtras();
      itemsCubit.clearSizes();
      itemsCubit.clearComponents();
    }
  }

  @override
  void onImageTap(int? itemId) {
    itemsCubit.setImage(itemId: itemId);
  }

  @override
  void onImage2Tap(int? itemId) {
    itemsCubit.setImage2(itemId: itemId);
  }

  @override
  void onCategoryChanged(CategoryModel? category) {
    itemsCubit.setCategory(category?.id);
    nameArFocusNode.requestFocus();
  }

  @override
  void onNameArChanged(String nameAr) {
    itemsCubit.setNameAr(nameAr);
  }

  @override
  void onNameArSubmitted(String nameAr) {
    nameEnFocusNode.requestFocus();
  }

  @override
  void onNameEnChanged(String nameEn) {
    itemsCubit.setNameEn(nameEn);
  }

  @override
  void onNameEnSubmitted(String nameEn) {
    nameEnFocusNode.unfocus();
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void onDescriptionArChanged(String descriptionAr) {
    itemsCubit.setDescriptionAr(descriptionAr);
  }

  @override
  void onDescriptionArSubmitted(String descriptionAr) {
    descriptionEnFocusNode.requestFocus();
  }

  @override
  void onDescriptionEnChanged(String descriptionEn) {
    itemsCubit.setDescriptionEn(descriptionEn);
  }

  @override
  void onDescriptionEnSubmitted(String descriptionEn) {
    priceFocusNode.requestFocus();
  }

  @override
  void onIsPanoramaSelected(IsPanoramaEnum? isPanoramaEnum) {
    itemsCubit.setIsPanorama(isPanoramaEnum?.id);
    isPanoramaFocusNode.unfocus();
  }

  @override
  void onPriceChanged(String price) {
    itemsCubit.setPrice(price);
  }

  @override
  void onPriceSubmitted(String price) {
    isPanoramaFocusNode.requestFocus();
  }

  @override
  void onAddExtraItem() {
    itemsCubit.addExtra(widget.item);
  }

  @override
  void onNameArExtraChanged(String nameAr, int index) {
    itemsCubit.setNameArExtra(nameAr, index);
  }

  @override
  void onNameEnExtraChanged(String nameEn, int index) {
    itemsCubit.setNameEnExtra(nameEn, index);
  }

  @override
  void onPriceExtraChanged(String price, int index) {
    itemsCubit.setPriceExtra(price, index);
  }

  @override
  void onRemoveExtra(int index) {
    itemsCubit.removeExtra(widget.item, index);
  }

  @override
  void onSetImageExtra(int index, int? itemId) {
    itemsCubit.setImageExtra(index, itemId: itemId);
  }

  @override
  void onAddSizeItem() {
    itemsCubit.addSize(widget.item);
  }

  @override
  void onNameArSizeChanged(String nameAr, int index) {
    itemsCubit.setNameArSize(nameAr, index);
  }

  @override
  void onNameEnSizeChanged(String nameEn, int index) {
    itemsCubit.setNameEnSize(nameEn, index);
  }

  @override
  void onPriceSizeChanged(String price, int index) {
    itemsCubit.setPriceSize(price, index);
  }

  @override
  void onSetImageSize(int index, int? itemId) {
    itemsCubit.setImageSize(index, itemId: itemId);
  }

  @override
  void onDescriptionArSizeChanged(String desc, int index) {
    itemsCubit.setDescriptionArSize(desc, index);
  }

  @override
  void onDescriptionEnSizeChanged(String desc, int index) {
    itemsCubit.setDescriptionEnSize(desc, index);
  }

  @override
  void onRemoveSize(int index) {
    itemsCubit.removeSize(widget.item, index);
  }

  @override
  void onAddComponentItem() {
    itemsCubit.addComponent(widget.item);
  }

  @override
  void onNameArComponentChanged(String nameAr, int index) {
    itemsCubit.setNameArComponent(nameAr, index);
  }

  @override
  void onNameEnComponentChanged(String nameEn, int index) {
    itemsCubit.setNameEnComponent(nameEn, index);
  }

  @override
  void onIsBasicComponentChanged(bool isBasic, int componentIndex) {
    final cubit = itemsCubit;
    cubit.setIsBasicComponent(
      isBasic ? IsBasicComponent.yes : IsBasicComponent.no,
      componentIndex, // استخدام index المكون الصحيح
    );
  }

  @override
  void onRemoveComponent(int index) {
    itemsCubit.removeComponent(widget.item, index);
  }

  @override
  void onAddNutritionItem() {
    itemsCubit.addNutrition();
  }

  @override
  void onRemoveNutritionItem() {
    itemsCubit.removeNutrition();
  }

  @override
  void onSaveTap() {
    final selectedCategoryId = itemsCubit.editItemModel.categoryId;

    // ✅ تضمين التصنيف الممرر ضمن allCategories
    final allCategories = [
      ...(homeCubit.localSubCategories ?? []),
      if (homeCubit.state is SubCategoriesInMasterSuccess)
        ...(homeCubit.state as SubCategoriesInMasterSuccess).categories,
      widget.category, // ✅ التصنيف الأساسي الممرر
    ];

    final selectedCategory = allCategories.firstWhereOrNull(
          (c) => c.id == selectedCategoryId,
    );

    final isMainCategoryWithSub = selectedCategory != null &&
        selectedCategory.categoryId == null &&
        selectedCategory.content == 1;

    if (isMainCategoryWithSub) {
      MainSnackBar.showErrorMessage(
        context,
        "لا يمكن إضافة عنصر إلى تصنيف رئيسي يحتوي على تصنيفات فرعية.".tr(),
      );
      return;
    }

    // ✅ إذا كل شيء سليم، احفظ العنصر
    itemsCubit.editItem(
      isEdit: widget.isEdit,
      itemId: widget.item?.id,
    );
  }

  @override
  void dispose() {
    categoryFocusNode.dispose();
    nameArFocusNode.dispose();
    nameEnFocusNode.dispose();
    descriptionArFocusNode.dispose();
    descriptionEnFocusNode.dispose();
    priceFocusNode.dispose();
    isPanoramaFocusNode.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        itemsCubit.resetModel();
      }
    });

    //  itemsCubit.resetModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    IsPanoramaEnum? isPanorama;
    if (item == null) {
      isPanorama = null;
    } else {
      isPanorama = IsPanoramaEnum.values.firstWhere(
            (element) => item.isPanorama == element.id,
      );
    }

    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                const Spacer(),
                Text(
                  widget.isEdit ? "edit_item".tr() : "add_item".tr(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onIgnoreTap,
                  child: const Icon(Icons.close, color: AppColors.black),
                ),
              ],
            ),
            const SizedBox(height: 30),
            BlocBuilder<ItemsCubit, GeneralItemsState>(
              buildWhen: (previous, current) => current is ItemImageUpdated,
              builder: (context, state) {
                final cubit = itemsCubit;

                final selectedImage =
                state is ItemImageUpdated ? state.selectedImage : null;
                final selectedImage2 =
                state is ItemImageUpdated ? state.selectedImage2 : null;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          EditItemImageSection(
                            networkImage: widget.item?.image,
                            tempImage: selectedImage,
                            onImageSelected: (_) =>
                                cubit.setImage(itemId: widget.item?.id),
                            isMainImage: true,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 20),
                      Column(
                        children: [
                          EditItemImageSection(
                            networkImage: widget.item?.icon,
                            tempImage: selectedImage2,
                            onImageSelected: (_) =>
                                cubit.setImage2(itemId: widget.item?.id),
                            isMainImage: false,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            MainTextField(
              initialText: widget.item?.nameAr,
              onChanged: onNameArChanged,
              onSubmitted: onNameArSubmitted,
              focusNode: nameArFocusNode,
              title: "name_ar".tr(),
              borderColor: widget.restaurant.color,
            ),
            MainTextField(
              initialText: widget.item?.nameEn,
              onChanged: onNameEnChanged,
              onSubmitted: onNameEnSubmitted,
              focusNode: nameEnFocusNode,
              title: "name_en".tr(),
              borderColor: widget.restaurant.color,
            ),
            MainTextField(
              initialText: widget.item?.descriptionAr,
              onChanged: onDescriptionArChanged,
              onSubmitted: onDescriptionArSubmitted,
              focusNode: descriptionArFocusNode,
              title: "description_ar".tr(),
              borderColor: widget.restaurant.color,
            ),
            MainTextField(
              initialText: widget.item?.descriptionEn,
              onChanged: onDescriptionEnChanged,
              onSubmitted: onDescriptionEnSubmitted,
              focusNode: descriptionEnFocusNode,
              title: "description_en".tr(),
              borderColor: widget.restaurant.color,
            ),
            MainTextField(
              initialText: widget.item?.price,
              onChanged: onPriceChanged,
              onSubmitted: onPriceSubmitted,
              focusNode: priceFocusNode,
              title: "price".tr(),
              textInputType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              borderColor: widget.restaurant.color,
            ),
            const SizedBox(height: 20),
            MainDropDownWidget<IsPanoramaEnum>(
              items: IsPanoramaEnum.values,
              text: "panorama".tr(),
              onChanged: onIsPanoramaSelected,
              focusNode: isPanoramaFocusNode,
              selectedValue: isPanorama,
            ),
            const SizedBox(height: 20),
            Text(
              "nutrition_info".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            _buildNutritionFields(),
            const SizedBox(height: 20),
            Text(
              "extras".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            _buildExtrasFields(),
            const SizedBox(height: 5),
            MainActionButton(
              padding: AppConstants.paddingH16V8,
              onPressed: onAddExtraItem,
              text: "add_extra_item".tr(),
              buttonColor: AppColors.white,
              textColor: AppColors.blueShade3,
              fontWeight: FontWeight.w700,
              border: Border.all(color: AppColors.blueShade3),
            ),
            const SizedBox(height: 20),
            Text(
              "sizes".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            _buildSizesFields(),
            const SizedBox(height: 5),
            MainActionButton(
              padding: AppConstants.paddingH16V8,
              onPressed: onAddSizeItem,
              text: "add_size_item".tr(),
              buttonColor: AppColors.white,
              textColor: AppColors.blueShade3,
              fontWeight: FontWeight.w700,
              border: Border.all(color: AppColors.blueShade3),
            ),
            const SizedBox(height: 20),
            Text(
              "components".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            _buildComponentsFields(),
            const SizedBox(height: 5),
            MainActionButton(
              padding: AppConstants.paddingH16V8,
              onPressed: onAddComponentItem,
              text: "add_component_item".tr(),
              buttonColor: AppColors.white,
              textColor: AppColors.blueShade3,
              fontWeight: FontWeight.w700,
              border: Border.all(color: AppColors.blueShade3),
            ),
            const SizedBox(height: 20),
            _buildMainActionButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionFieldWithUnit({
    required String label,
    required double? value,
    required String unit,
    required Function(double?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: TextEditingController(
                    text: value?.toStringAsFixed(2) ?? '',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    suffixText: unit,
                  ),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  onChanged: (val) => onChanged(double.tryParse(val)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // دالة مساعدة لبناء حقول التغذية
  Widget _buildNutritionField({
    required String label,
    required double? value,
    required Function(double?) onChanged,
    String unit = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: TextEditingController(
              text: value?.toStringAsFixed(2) ?? '',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              suffixText: unit,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            onChanged: (val) => onChanged(double.tryParse(val)),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionFields() {
    return BlocBuilder<ItemsCubit, GeneralItemsState>(
      buildWhen: (prev, curr) => curr is NutritionState,
      builder: (context, state) {
        final cubit = itemsCubit;
        final nutrition = cubit.editItemModel.nutrition;

        if (state is NutritionAdded) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان مع زر الحذف
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.food_bank, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "nutrition_info".tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: onRemoveNutritionItem,
                        icon: const Icon(Icons.delete, color: AppColors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // اختيار الوحدة
                  DropdownButtonFormField<String>(
                    value: nutrition?.unit ?? 'g',
                    items: ['g', 'ml', 'kg', 'L'].map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'unit'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (newUnit) {
                      cubit.editItemModel = cubit.editItemModel.copyWith(
                        nutrition: nutrition?.copyWith(unit: newUnit),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // الوزن
                  _buildNutritionFieldWithUnit(
                    label: 'weight'.tr(),
                    value: nutrition?.amount,
                    unit: nutrition?.unit ?? 'g',
                    onChanged: (val) {
                      cubit.editItemModel = cubit.editItemModel.copyWith(
                        nutrition: nutrition?.copyWith(amount: val),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // السعرات والبروتين
                  Row(
                    children: [
                      Expanded(
                        child: _buildNutritionField(
                          label: 'calories_kcal'.tr(),
                          value: nutrition?.kcal,
                          onChanged: (val) {
                            cubit.editItemModel = cubit.editItemModel.copyWith(
                              nutrition: nutrition?.copyWith(kcal: val),
                            );
                          },
                          unit: 'kcal',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildNutritionField(
                          label: 'protein'.tr(),
                          value: nutrition?.protein,
                          onChanged: (val) {
                            cubit.editItemModel = cubit.editItemModel.copyWith(
                              nutrition: nutrition?.copyWith(protein: val),
                            );
                          },
                          unit: nutrition?.unit ?? 'g',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // الدهون والكربوهيدرات
                  Row(
                    children: [
                      Expanded(
                        child: _buildNutritionField(
                          label: 'fat'.tr(),
                          value: nutrition?.fat,
                          onChanged: (val) {
                            cubit.editItemModel = cubit.editItemModel.copyWith(
                              nutrition: nutrition?.copyWith(fat: val),
                            );
                          },
                          unit: nutrition?.unit ?? 'g',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildNutritionField(
                          label: 'carbs'.tr(),
                          value: nutrition?.carbs,
                          onChanged: (val) {
                            cubit.editItemModel = cubit.editItemModel.copyWith(
                              nutrition: nutrition?.copyWith(carbs: val),
                            );
                          },
                          unit: nutrition?.unit ?? 'g',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return MainActionButton(
            padding: AppConstants.paddingH16V8,
            onPressed: onAddNutritionItem,
            text: "add_nutrition_info".tr(),
            buttonColor: AppColors.white,
            textColor: AppColors.blueShade3,
            fontWeight: FontWeight.w700,
            border: Border.all(color: AppColors.blueShade3),
          );
        }
      },
    );
  }

  Widget _buildExtrasFields() {
    return BlocBuilder<ItemsCubit, GeneralItemsState>(
      buildWhen: (previous, current) => current is ExtrasState,
      builder: (context, state) {
        if (state is ExtrasSuccess) {
          return Column(
            children: List.generate(
              state.extras.length,
                  (index) {
                final extra = state.extras[index];
                final image = itemsCubit.getExtraImage(index);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: EditItemImageSection(
                        networkImage: extra.icon,
                        tempImage: image,
                        isMainImage: true, // or false, if needed
                        onImageSelected: (file) => setState(() {
                          onSetImageExtra(index, widget.item?.id);
                        }),
                      ),
                    ),
                    const SizedBox(height: 5),
                    MainTextField(
                      initialText: extra.nameAr,
                      title: 'name_ar'.tr(),
                      onChanged: (value) => onNameArExtraChanged(value, index),
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 5),
                    MainTextField(
                      initialText: extra.nameEn,
                      title: 'name_en'.tr(),
                      onChanged: (value) => onNameEnExtraChanged(value, index),
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 5),
                    MainTextField(
                      initialText: extra.price,
                      title: 'price'.tr(),
                      onChanged: (value) => onPriceExtraChanged(value, index),
                      textInputType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 20),
                    MainActionButton(
                      padding: AppConstants.padding8,
                      onPressed: () => onRemoveExtra(index),
                      text: "Delete",
                      buttonColor: AppColors.redShade2,
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildSizesFields() {
    return BlocBuilder<ItemsCubit, GeneralItemsState>(
      buildWhen: (previous, current) => current is SizesState,
      builder: (context, state) {
        if (state is SizesSuccess) {
          return Column(
            children: List.generate(
              state.sizes.length,
                  (index) {
                final size = state.sizes[index];
                final image = itemsCubit.getSizeImage(index);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: EditItemImageSection(
                        networkImage: size.image,
                        tempImage: image,
                        isMainImage: true, // or false, if needed
                        onImageSelected: (file) => setState(() {
                          onSetImageExtra(index, widget.item?.id);
                        }),
                      ),
                    ),
                    const SizedBox(height: 5),
                    MainTextField(
                      initialText: size.nameAr,
                      title: 'name_ar'.tr(),
                      onChanged: (value) => onNameArSizeChanged(value, index),
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 5),
                    MainTextField(
                      initialText: size.nameEn,
                      title: 'name_en'.tr(),
                      onChanged: (value) => onNameEnSizeChanged(value, index),
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 5),
                    MainTextField(
                      initialText: size.price,
                      title: 'price'.tr(),
                      onChanged: (value) => onPriceSizeChanged(value, index),
                      textInputType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 5),
                    MainTextField(
                      initialText: size.descriptionAr,
                      title: 'description_ar'.tr(),
                      onChanged: (value) =>
                          onDescriptionArSizeChanged(value, index),
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 5),
                    MainTextField(
                      initialText: size.descriptionEn,
                      title: 'description_en'.tr(),
                      onChanged: (value) =>
                          onDescriptionEnSizeChanged(value, index),
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 20),
                    MainActionButton(
                      padding: AppConstants.padding8,
                      onPressed: () => onRemoveSize(index),
                      text: "Delete",
                      buttonColor: AppColors.redShade2,
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildComponentsFields() {
    return BlocBuilder<ItemsCubit, GeneralItemsState>(
      buildWhen: (previous, current) => current is ComponentsState,
      builder: (context, state) {
        if (state is ComponentsSuccess) {
          return Column(
            children: List.generate(
              state.components.length,
                  (index) {
                final component = state.components[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainTextField(
                      initialText: component.nameAr,
                      title: 'name_ar'.tr(),
                      onChanged: (value) =>
                          onNameArComponentChanged(value, index),
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 5),
                    MainTextField(
                      initialText: component.nameEn,
                      title: 'name_en'.tr(),
                      onChanged: (value) =>
                          onNameEnComponentChanged(value, index),
                      borderColor: widget.restaurant.color,
                    ),
                    const SizedBox(height: 5),
                    ToggleSwitch(
                      minWidth: 150.0,
                      minHeight: 40.0,
                      initialLabelIndex:
                      component.isBasicComponent == IsBasicComponent.yes
                          ? 0
                          : 1,
                      totalSwitches: 2,
                      labels: ["optional".tr(), "basic".tr()],
                      activeBgColor: const [AppColors.primaryDark],
                      activeFgColor: AppColors.white,
                      inactiveBgColor: AppColors.grey.shade100,
                      inactiveFgColor: AppColors.black,
                      cornerRadius: 8.0,
                      borderWidth: 1.5,
                      borderColor: const [AppColors.primaryLight],
                      animate: true,
                      animationDuration: 300,
                      curve: Curves.easeInOut,
                      onToggle: (switchIndex) {
                        HapticFeedback.lightImpact();
                        if (switchIndex != null) {
                          onIsBasicComponentChanged(switchIndex == 0, index);
                        }
                      },
                      customIcons: const [
                        Icon(Icons.star, color: AppColors.white),
                        Icon(Icons.star_border, color: AppColors.grey),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MainActionButton(
                      padding: AppConstants.padding8,
                      onPressed: () => onRemoveComponent(index),
                      text: "Delete",
                      buttonColor: AppColors.redShade2,
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildMainActionButtons() {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          flex: 4,
          child: MainActionButton(
            onPressed: onIgnoreTap,
            padding: AppConstants.paddingV10,
            buttonColor: widget.restaurant.color,
            text: "cancel".tr(),
          ),
        ),
        const SizedBox(width: 8),
        BlocConsumer<ItemsCubit, GeneralItemsState>(
          listener: (context, state) {
            if (state is EditItemSuccess) {
              itemsCubit.getItems(
                categoryId: widget.category.id,
                isRefresh: true,
              );
              onIgnoreTap();
              MainSnackBar.showSuccessMessage(context, state.message);
            } else if (state is EditItemFail) {
              MainSnackBar.showErrorMessage(context, state.error);
            }
          },
          builder: (context, state) {
            return Expanded(
              flex: 4,
              child: MainActionButton(
                onPressed: onSaveTap,
                padding: AppConstants.paddingV10,
                buttonColor: widget.restaurant.color,
                text: "save".tr(),
                isLoading: state is EditItemLoading,
              ),
            );
          },
        ),
        const Spacer(),
      ],
    );
  }
}
