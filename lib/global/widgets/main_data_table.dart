import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';

class MainDataTable extends StatelessWidget {
  const MainDataTable({
    super.key,
    required this.titles,
    required this.rows,
  });

  final List<String> titles;
  final List<DataRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppConstants.borderRadius10,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          headingRowColor: const WidgetStatePropertyAll(
            AppColors.mainColor,
          ),
          columns: List.generate(
            titles.length,
            (index) {
              return DataColumn(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text(
                  titles[index],
                  style: const TextStyle(
                    color: AppColors.white,
                  ),
                ),
              );
            },
          ),
          rows: rows,
        ),
      ),
    );
  }
}
