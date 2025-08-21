import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';

class MainDataTable extends StatelessWidget {
  const MainDataTable({
    super.key,
    required this.titles,
    required this.rows,
    this.color,
  });

  final List<String> titles;
  final List<DataRow> rows;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        border: TableBorder.all(width: 1.5),
        dataTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        headingRowColor: WidgetStatePropertyAll(
          color ?? AppColors.mainColor,
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
    );
  }
}

