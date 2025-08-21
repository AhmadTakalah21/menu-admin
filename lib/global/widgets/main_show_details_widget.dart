
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/constants.dart';

class IconTitleValueModel {
  final IconData icon;
  final String title;
  final String value;
  IconTitleValueModel({
    required this.icon,
    required this.title,
    required this.value,
  });
}

abstract class DetailsModel {
  int get id;
  List<IconTitleValueModel> get tiles;
  String? get image;
}

class MainShowDetailsWidget<T extends DetailsModel> extends StatelessWidget {
  const MainShowDetailsWidget({
    super.key,
    required this.model,
    this.favoriteIcon,
    this.iconOnImage,
    this.onIconOnImageTap,
  });

  final T model;
  final Widget? favoriteIcon;
  final Widget? iconOnImage;
  final void Function(BuildContext context,T)? onIconOnImageTap;

  void onCancelTap(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      title: SizedBox(width: MediaQuery.sizeOf(context).width - 40),
      titlePadding: AppConstants.padding0,
      content: SingleChildScrollView(
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                if (favoriteIcon != null) favoriteIcon!,
                const Spacer(),
                Text(
                  "details".tr(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => onCancelTap(context),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.black,
                    size: 30,
                  ),
                ),
              ],
            ),
            if (model.image != null)
              Padding(
                padding: AppConstants.padding16,
                child: Stack(
                  children: [
                    // AppImageWidget(
                    //   url: model.image!,
                    //   borderRadius: AppConstants.borderRadius15,
                    //   shadows: AppColors.thirdShadow,
                    //   errorWidget: Image.asset("assets/images/app_logo.png"),
                    // ),
                    if (iconOnImage != null)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: InkWell(
                          onTap: () => onIconOnImageTap?.call(context,model),
                          child: iconOnImage!,
                        ),
                      ),
                  ],
                ),
              ),
            ...model.tiles.map(
              (tile) => Padding(
                padding: AppConstants.paddingR5,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.whiteShade,
                    borderRadius: AppConstants.borderRadius15,
                  ),
                  child: Padding(
                    padding: AppConstants.padding10,
                    child: Row(
                      children: [
                        Text(
                          "${tile.title.tr()} : ",
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(child: Text(tile.value)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
