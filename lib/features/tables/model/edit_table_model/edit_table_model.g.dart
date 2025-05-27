// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditTableModel _$EditTableModelFromJson(Map<String, dynamic> json) =>
    EditTableModel(
      id: (json['id'] as num?)?.toInt(),
      tableNumber: json['number_table'] as String?,
      isQrTable: (json['is_qr_table'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EditTableModelToJson(EditTableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number_table': instance.tableNumber,
      'is_qr_table': instance.isQrTable,
    };
