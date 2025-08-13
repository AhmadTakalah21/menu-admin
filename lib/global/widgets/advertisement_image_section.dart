import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';

class AdvertisementImageSection extends StatefulWidget {
  final String? networkImage;
  final XFile? tempImage;
  final void Function(XFile? image) onImageSelected;

  const AdvertisementImageSection({
    super.key,
    required this.networkImage,
    required this.onImageSelected, this.tempImage,
  });

  @override
  State<AdvertisementImageSection> createState() => _AdvertisementImageSectionState();
}

class _AdvertisementImageSectionState extends State<AdvertisementImageSection> {
  XFile? localImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    try {
      setState(() => isLoading = true);
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => localImage = picked);
        widget.onImageSelected(picked);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
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
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      );
    } else if (widget.networkImage != null && widget.networkImage!.isNotEmpty) {
      imageWidget = AppImageWidget(
        url: widget.networkImage!,
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      );
    } else {
      imageWidget = Image.asset(
        'assets/images/upload_image.png',
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      );
    }

    return Column(
      children: [
        InkWell(
          onTap: pickImage,
          child: imageWidget,
        ),
        const SizedBox(height: 8),
        const Text(
          'إعلان',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
