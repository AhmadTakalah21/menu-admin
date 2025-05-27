// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModel _$TableModelFromJson(Map<String, dynamic> json) => TableModel(
      id: (json['id'] as num).toInt(),
      tableNumber: const IntConverter().fromJson(json['number_table']),
      number: const IntConverter().fromJson(json['num']),
      waiter: const BoolConverter().fromJson(json['waiter']),
      arakel: const BoolConverter().fromJson(json['arakel']),
      invoice: const BoolConverter().fromJson(json['invoice']),
      newOrder: const BoolConverter().fromJson(json['new_order']),
      isQrTable: const BoolConverter().fromJson(json['is_qr_table']),
      tableStatus: (json['new'] as num).toInt(),
      qrCode: json['qr_code'] as String?,
    );

Map<String, dynamic> _$TableModelToJson(TableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number_table': const IntConverter().toJson(instance.tableNumber),
      'num': const IntConverter().toJson(instance.number),
      'waiter': const BoolConverter().toJson(instance.waiter),
      'arakel': const BoolConverter().toJson(instance.arakel),
      'invoice': const BoolConverter().toJson(instance.invoice),
      'new_order': const BoolConverter().toJson(instance.newOrder),
      'is_qr_table': const BoolConverter().toJson(instance.isQrTable),
      'new': instance.tableStatus,
      'qr_code': instance.qrCode,
    };
