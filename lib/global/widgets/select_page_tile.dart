import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';

class SelectPageTile extends StatelessWidget {
  const SelectPageTile({
    super.key,
    required this.length,
    required this.selectedPage,
    required this.onSelectPageTap,
  });

  final int length;
  final int selectedPage;
  final ValueSetter<int> onSelectPageTap;

  @override
  Widget build(BuildContext context) {
    if (length > 1) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  length,
                  (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MainActionButton(
                          padding: AppConstants.padding12,
                          onPressed: () => onSelectPageTap(index + 1),
                          text: (index + 1).toString(),
                          buttonColor: selectedPage == index + 1
                              ? AppColors.mainColor
                              : AppColors.white,
                          textColor: selectedPage == index + 1
                              ? AppColors.white
                              : AppColors.black,
                        ),
                        const SizedBox(width: 10),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
