import 'package:flutter/material.dart';

class MoreOptionsWidget<T> extends StatelessWidget {
  const MoreOptionsWidget({
    super.key,
    required this.item,
    this.onShowDetailsTap,
    this.onEditTap,
    this.onDeleteTap,
    this.customeButtons = const [],
  });
  final T item;
  final void Function(T item)? onShowDetailsTap;
  final void Function(T item)? onEditTap;
  final void Function(T item)? onDeleteTap;
  final List<Widget> customeButtons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...customeButtons.map((button) => button),
          if (onShowDetailsTap != null)
            ActionTile(
              icon: Icons.remove_red_eye_outlined,
              label: 'عرض التفاصيل',
              onTap: () => onShowDetailsTap?.call(item),
            ),
          if (onEditTap != null)
            ActionTile(
              icon: Icons.edit_outlined,
              label: 'تعديل',
              onTap: () => onEditTap?.call(item),
            ),
          if (onDeleteTap != null)
            ActionTile(
              icon: Icons.delete_outline,
              label: 'حذف',
              isDestructive: true,
              onTap: () => onDeleteTap?.call(item),
            ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFE53935) : Colors.black87;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.of(context).pop();
        onTap?.call();
      },
    );
  }
}
