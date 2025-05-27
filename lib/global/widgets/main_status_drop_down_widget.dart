import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainStatusDropDownWidget extends StatelessWidget {
  final List<String> statusOptions;
  final String selectedStatus;
  final void Function(String? status) onChanged;
  final FocusNode? focusNode;

  const MainStatusDropDownWidget({
    super.key,
    required this.statusOptions,
    required this.selectedStatus,
    required this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    if (!statusOptions.contains(selectedStatus)) {
      statusOptions.add(selectedStatus);
    }

    return DropdownButtonFormField<String>(
      value: selectedStatus,
      decoration: InputDecoration(
        labelText: 'Status'.tr(),
        border: const OutlineInputBorder(),
      ),
      items: statusOptions.map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status.tr()),
        );
      }).toList(),
      onChanged: onChanged,
      focusNode: focusNode,
    );
  }
}
