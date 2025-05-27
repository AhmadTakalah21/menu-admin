import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AddNutritionItemModel {
  final int? id;
  final double? amount;
  final String? unit;
  final double? kcal;
  final double? protein;
  final double? fat;
  final double? carbs;

  const AddNutritionItemModel({
    this.id,
    this.amount,
    this.unit,
    this.kcal,
    this.protein,
    this.fat,
    this.carbs,
  });

  /// ✅ `fromJson` يدوي
  factory AddNutritionItemModel.fromJson(Map<String, dynamic> json) {
    return AddNutritionItemModel(
      id: json['id'] as int?,
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
      unit: json['unit'] as String?,
      kcal: json['kcal'] != null
          ? double.tryParse(json['kcal'].toString())
          : null,
      protein: json['protein'] != null
          ? double.tryParse(json['protein'].toString())
          : null,
      fat: json['fat'] != null
          ? double.tryParse(json['fat'].toString())
          : null,
      carbs: json['carbs'] != null
          ? double.tryParse(json['carbs'].toString())
          : null,
    );
  }

  /// ✅ `toJson` يدوي
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'unit': unit,
      'kcal': kcal,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
    };
  }

  /// ✅ خصائص مساعدة للوصول الآمن
  double get safeAmount => amount ?? 0.0;
  String get safeUnit => unit ?? 'g';
  double get safeKcal => kcal ?? 0.0;
  double get safeProtein => protein ?? 0.0;
  double get safeFat => fat ?? 0.0;
  double get safeCarbs => carbs ?? 0.0;

  /// ✅ نسخة جديدة مع تعديلات
  AddNutritionItemModel copyWith({
    double? amount,
    String? unit,
    double? kcal,
    double? protein,
    double? fat,
    double? carbs,
  }) {
    return AddNutritionItemModel(
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      kcal: kcal ?? this.kcal,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
    );
  }

  /// ✅ نسخة فارغة
  factory AddNutritionItemModel.empty() => const AddNutritionItemModel(
    amount: 0,
    unit: 'g',
    kcal: 0,
    protein: 0,
    fat: 0,
    carbs: 0,
  );
}
