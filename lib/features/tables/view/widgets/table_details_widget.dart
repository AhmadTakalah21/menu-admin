import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

abstract class TableDetailsWidgetCallBack {
  Future<void> onShareTap();

  void onDownloadTap();

  void onIgnoreTap();
}

class TableDetailsWidget extends StatefulWidget {
  const TableDetailsWidget({
    super.key,
    required this.qrCode,
    required this.title,
  });

  final String qrCode;
  final String title;

  @override
  State<TableDetailsWidget> createState() => _TableDetailsWidgetState();
}

class _TableDetailsWidgetState extends State<TableDetailsWidget>
    implements TableDetailsWidgetCallBack {
  @override
  Future<void> onShareTap() async {
    final result = await Share.share(widget.qrCode);

    if (!mounted) return;
    if (result.status == ShareResultStatus.success) {
      MainSnackBar.showSuccessMessage(context, "qr_shared".tr());
    } else if (result.status == ShareResultStatus.dismissed) {
      MainSnackBar.showErrorMessage(context, "share_dismissed".tr());
    }
  }

  @override
  void onDownloadTap() {
    showDialog(
      barrierColor: Colors.black,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.black,
        contentPadding: AppConstants.padding0,
        content: AppImageWidget(
          url: widget.qrCode,
        ),
      ),
    );
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.title,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onIgnoreTap,
                  child: const Icon(
                    Icons.close,
                    color: AppColors.greyShade,
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            AppImageWidget(
              url: widget.qrCode,
              errorWidget:  SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    "no_image".tr(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: onDownloadTap,
              child: const Icon(Icons.download_for_offline, size: 60),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: onShareTap,
              child: const Icon(Icons.share_sharp, size: 60),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
