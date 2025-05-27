import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImagePlaceHolderWidget extends StatelessWidget {
  const ImagePlaceHolderWidget({
    super.key,
    this.height,
    this.radius = 12,
  });

  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Shimmer.fromColors(
        baseColor:  Colors.grey.withOpacity(0.5),
        highlightColor: const Color(0xFFF5F1FE),
        child: Container(
          height: height,
        color:  Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}
