import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_admin/global/widgets/image_place_holder_widget.dart';

class AppImageWidget extends StatelessWidget {
  const AppImageWidget({
    super.key,
    required this.url,
    this.borderRadius = BorderRadius.zero,
    this.fit,
    this.width,
    this.height,
    this.border,
    this.shadows,
    this.errorWidget,
    this.scale = 1,
    this.backgroundColor,
  });

  final String url;
  final BorderRadiusGeometry borderRadius;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Border? border;
  final List<BoxShadow>? shadows;
  final Widget? errorWidget;
  final double scale;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: [...?shadows],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          scale: scale,
          imageUrl: url,
          fit: fit,
          errorWidget: (context, url, error) {
            return errorWidget ??
                const Center(
                  child: Text(
                    "Failed to load image",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
          },
          placeholder: (context, url) => const ImagePlaceHolderWidget(),
        ),
      ),
    );
  }
}
