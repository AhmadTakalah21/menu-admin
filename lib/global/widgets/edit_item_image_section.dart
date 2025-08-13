import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';

class EditItemImageSection extends StatefulWidget {
  final String? networkImage;
  final XFile? tempImage;
  final void Function(XFile? image) onImageSelected;
  final bool isMainImage;

  const EditItemImageSection({
    super.key,
    required this.networkImage,
    this.tempImage,
    required this.onImageSelected,
    this.isMainImage = true,
  });

  @override
  State<EditItemImageSection> createState() => _EditItemImageSectionState();
}

class _EditItemImageSectionState extends State<EditItemImageSection> {
  XFile? localImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    try {
      setState(() => isLoading = true);
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          localImage = picked;
        });
        widget.onImageSelected(picked);
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (isLoading) {
      imageWidget = const LoadingIndicator();
    } else if (localImage != null) {
      imageWidget = Image.file(
        File(localImage!.path),
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    } else if (widget.networkImage != null && widget.networkImage!.isNotEmpty) {
      imageWidget = AppImageWidget(
        url: widget.networkImage!,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Image.asset(
        "assets/images/upload_image.png",
        width: 150,
        height: 150,
      );
    }

    return Column(
      children: [
        InkWell(
          onTap: pickImage,
          child: imageWidget,
        ),
        const SizedBox(height: 8),
        Text(widget.isMainImage ? "product_image".tr() : "product_icon".tr()),
      ],
    );
  }
}
