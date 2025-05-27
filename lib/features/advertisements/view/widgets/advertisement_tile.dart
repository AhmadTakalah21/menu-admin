import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_admin/features/advertisements/model/advertisement_model/advertisement_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';

class AdvertisementTile extends StatelessWidget {
  const AdvertisementTile({
    super.key,
    required this.advertisement,
    required this.restaurant,
    this.onEditTap,
    this.onDeleteTap,
  });

  final AdvertisementModel advertisement;
  final RestaurantModel restaurant;
  final ValueSetter<AdvertisementModel>? onEditTap;
  final ValueSetter<AdvertisementModel>? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final onEditTap = this.onEditTap;
    final onDeleteTap = this.onDeleteTap;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppConstants.borderRadius10,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: AppConstants.padding8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image with proper handling
            Center(
              child: ClipRRect(
                borderRadius: AppConstants.borderRadius10,
                child: AppImageWidget(
                  fit: BoxFit.cover, // Image will cover the available space while maintaining its aspect ratio
                  width: double.infinity, // Make sure it takes the full width
                  height: 200, // Define a fixed height for the image
                  url: advertisement.image,
                  errorWidget: SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        "no_image".tr(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Divider
            Container(
              height: 1,
              decoration: BoxDecoration(
                color: AppColors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Title Text
            Text(
              advertisement.title.toUpperCase(),
              style: TextStyle(
                color: restaurant.fColorCategory,
                overflow: TextOverflow.ellipsis,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            // From Date
            Text(
              advertisement.fromDate,
              style: TextStyle(
                color: restaurant.fColorCategory,
                overflow: TextOverflow.ellipsis,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            // To Date
            Text(
              advertisement.toDate,
              style: TextStyle(
                color: restaurant.fColorCategory,
                overflow: TextOverflow.ellipsis,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            // Edit and Delete Actions
            if (onEditTap != null || onDeleteTap != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onDeleteTap != null)
                    InkWell(
                      onTap: () => onDeleteTap(advertisement),
                      child: const Icon(Icons.delete, size: 30),
                    ),
                  if (onEditTap != null && onDeleteTap != null)
                    const SizedBox(width: 30),
                  if (onEditTap != null)
                    InkWell(
                      onTap: () => onEditTap(advertisement),
                      child: const Icon(Icons.edit_outlined, size: 30),
                    ),
                ],
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
