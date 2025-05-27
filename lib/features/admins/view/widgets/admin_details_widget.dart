import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/invoice_widget.dart';

class AdminDetailsWidget extends StatelessWidget {
  const AdminDetailsWidget({super.key, required this.admin});

  final AdminModel admin;

  void onIgnoreTap(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<TitleValueModel> details = [
      TitleValueModel("username".tr(), admin.userName),
      TitleValueModel("name".tr(), admin.name),
      TitleValueModel("role".tr(), admin.roles ?? "_"),
      TitleValueModel("active".tr(), admin.isActive ? "yes".tr() : "no".tr()),
      TitleValueModel("type".tr(), admin.type ?? "_"),
    ];
    final permissions = admin.permissions;

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
                const Spacer(),
                const SizedBox(width: 20),
                Text(
                  "details".tr(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
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
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: details
                  .map(
                    (detail) => Container(
                      decoration: BoxDecoration(
                        borderRadius: AppConstants.borderRadius20,
                        border: Border.all(color: AppColors.black),
                      ),
                      padding: AppConstants.padding16,
                      child: Text.rich(
                        style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                        TextSpan(
                          text: "${detail.title}: ",
                          children: [
                            TextSpan(
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                              text: detail.value,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              "permissins".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            if(permissions != null)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: permissions
                  .map(
                    (permission) => Container(
                      constraints: const BoxConstraints(
                        minWidth: 150,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: AppConstants.borderRadius20,
                        border: Border.all(color: AppColors.blueShade3),
                      ),
                      padding: AppConstants.padding16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            permission.name,
                            style: const TextStyle(
                              color: AppColors.blueShade3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
