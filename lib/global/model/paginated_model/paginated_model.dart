import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/global/model/meta_model/meta_model.dart';

part 'paginated_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
@immutable
class PaginatedModel<T> {
  const PaginatedModel({
    required this.data,
    required this.meta,
  });

  final List<T> data;
  final MetaModel meta;

  factory PaginatedModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$PaginatedModelToJson(this, toJsonT);

  @override
  String toString() => jsonEncode(toJson((item) => item as Object));

  static PaginatedModel<T> fromString<T>(
    String source,
    T Function(Object? json) fromJsonT,
  ) {
    final Map<String, dynamic> json = jsonDecode(source);
    return PaginatedModel.fromJson(json, fromJsonT);
  }
}
