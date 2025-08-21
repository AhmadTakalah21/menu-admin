import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_admin/global/localization/supported_locales.dart';
import 'package:user_admin/global/widgets/restart_app_widget.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.restaurant,
    this.title,
    this.automaticallyImplyLeading = true,
    this.onNotificationsTap,
    this.actions,

    // Search
    this.enableSearch = true,
    this.initialQuery,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchClosed,
    this.searchHintText,
    this.searchDebounceMs = 350,

    // Language
    this.enableLanguageToggle = true,
    this.onLanguageToggle,
  });

  final RestaurantModel restaurant;
  final String? title;
  final bool automaticallyImplyLeading;
  final VoidCallback? onNotificationsTap;
  final List<Widget>? actions;

  // Search
  final bool enableSearch;
  final String? initialQuery;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchClosed;
  final String? searchHintText;
  final int searchDebounceMs;

  // Language
  final bool enableLanguageToggle;
  final ValueChanged<Locale>? onLanguageToggle;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  bool _searching = false;
  late final TextEditingController _controller =
  TextEditingController(text: widget.initialQuery ?? '');
  Timer? _deb;

  @override
  void dispose() {
    _deb?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _searching = !_searching);
    if (_searching) {
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
      _notifyChanged(_controller.text);
    } else {
      _controller.clear();
      widget.onSearchClosed?.call();
      _notifyChanged('');
    }
  }

  void _notifyChanged(String q) {
    if (widget.onSearchChanged == null) return;
    _deb?.cancel();
    _deb = Timer(Duration(milliseconds: widget.searchDebounceMs), () {
      widget.onSearchChanged?.call(q.trim());
    });
  }

  void _submit(String q) {
    widget.onSearchSubmitted?.call(q.trim());
  }

  void _clear() {
    _controller.clear();
    _notifyChanged('');
  }

  Future<void> _changeLanguage(Locale next) async {
    await context.setLocale(next);
    widget.onLanguageToggle?.call(next);
    RestartAppWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    final brand = widget.restaurant.color ?? AppColors.mainColor;
    final isRTL = Directionality.of(context) == TextDirection.RTL;

    final searchBtn = IconButton(
      tooltip: tr('search'),
      onPressed: _toggleSearch,
      icon: const Icon(Icons.search, color: AppColors.white),
    );

    final languageBtn = PopupMenuButton<Locale>(
      tooltip: tr('language'),
      offset: const Offset(0, 50),
      constraints: const BoxConstraints(maxWidth: 62),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: widget.restaurant.color,
      onSelected: _changeLanguage,
      itemBuilder: (context) {
        return SupportedLocales.languages.map((lang) {
          return PopupMenuItem<Locale>(
            value: lang.locale,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  lang.code, // "AR" / "EN"
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textScaler: const TextScaler.linear(0.9),
                ),
              ),
            ),
          );
        }).toList();
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Icon(Icons.language, color: AppColors.white, size: 24),
      ),
    );

    // ترتيب اليسار/اليمين حسب اتجاه الواجهة
    final List<Widget> leftActions = [
      if (widget.enableSearch) searchBtn,
      if (widget.enableLanguageToggle) languageBtn,
    ];

    final mergedActions = <Widget>[
      if (isRTL) ...leftActions, ...(widget.actions ?? []),
      if (!isRTL) ...(widget.actions ?? []), if (!isRTL) ...leftActions,
      if (widget.onNotificationsTap != null)
        IconButton(
          tooltip: tr('notifications'),
          onPressed: widget.onNotificationsTap,
          icon: const Icon(Icons.notifications_none, color: AppColors.white),
        ),
      const SizedBox(width: 6),
    ];

    return AppBar(
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      iconTheme: const IconThemeData(color: AppColors.white),
      backgroundColor: brand,
      centerTitle: !_searching,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _searching
            ? _SearchField(
          key: const ValueKey('search-field'),
          controller: _controller,
          hint: widget.searchHintText ?? tr('search'),
          onChanged: _notifyChanged,
          onSubmitted: _submit,
          onClear: _clear,
          onClose: _toggleSearch,
        )
            : (widget.title != null
            ? Text(
          widget.title!,
          key: const ValueKey('title-text'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        )
            : const SizedBox.shrink()),
      ),
      actions: mergedActions,
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onClose,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      // نستخدم ValueListenableBuilder لنعكس تغيّر نص الحقل على الأيقونة فورًا
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          final hasText = value.text.isNotEmpty;
          return TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasText)
                    IconButton(
                      tooltip: tr('clear'),
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: onClear,
                    ),
                  IconButton(
                    tooltip: tr('close'),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.black54),
                    onPressed: onClose,
                  ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
            ),
          );
        },
      ),
    );
  }
}
