import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';

import '../utils/constants.dart';
import 'animations/splash_animation.dart';

class LogoLoadingIndicator extends StatelessWidget {
  const LogoLoadingIndicator({
    super.key,
    this.height,
    this.size,
    required this.restaurant,
    this.placeholderText,
  });

  final RestaurantModel? restaurant;
  final double? height;
  final double? size;
  final String? placeholderText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 500,
      child: Center(child: SplashAnimation(child: _buildLogo(context))),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getStoredLogo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        }

        String? storedLogo = snapshot.data;

        if (storedLogo != null && storedLogo.isNotEmpty) {
          return _getLogoWithShape(storedLogo);
        }

        if (restaurant == null || restaurant!.logoHomePage!.isEmpty) {
          return _buildPlaceholder();
        }

        return _getLogoWithShape(restaurant!.logoHomePage!);
      },
    );
  }

  Future<String?> _getStoredLogo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.restaurantLogo);
  }

  Widget _getLogoWithShape(String logoUrl) {
    switch (restaurant?.logoShape ?? 1) {
      case 1: // دائري
        return ClipOval(
          child: CachedNetworkImage(
            imageUrl: logoUrl,
            width: size ?? 400,
            height: size ?? 400,
            placeholder: (context, url) => _buildLoadingIndicator(),
            errorWidget: (context, url, error) => _buildPlaceholder(),
            fit: BoxFit.contain,
          ),
        );
      case 2:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: logoUrl,
            width: size ?? 350,
            height: size ?? 250,
            placeholder: (context, url) => _buildLoadingIndicator(),
            errorWidget: (context, url, error) => _buildPlaceholder(),
            fit: BoxFit.cover,
          ),
        );
      case 3:
        return ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: CachedNetworkImage(
            imageUrl: logoUrl,
            width: size ?? 300,
            height: size ?? 300,
            placeholder: (context, url) => _buildLoadingIndicator(),
            errorWidget: (context, url, error) => _buildPlaceholder(),
            fit: BoxFit.cover,
          ),
        );
      default:
        return ClipOval(
          child: CachedNetworkImage(
            imageUrl: logoUrl,
            width: size ?? 400,
            height: size ?? 400,
            placeholder: (context, url) => _buildLoadingIndicator(),
            errorWidget: (context, url, error) => _buildPlaceholder(),
            fit: BoxFit.contain,
          ),
        );
    }
  }

  Widget _buildLoadingIndicator() {
    return CircularProgressIndicator(
      valueColor:
          AlwaysStoppedAnimation<Color>(restaurant?.color ?? Colors.blue),
    );
  }

  Widget _buildPlaceholder() {
    return Icon(
      Icons.restaurant,
      size: size ?? 150,
      color: restaurant?.color ?? Colors.white,
    );
  }
}
