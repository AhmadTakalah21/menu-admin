import 'package:json_annotation/json_annotation.dart';

class BoolConverter implements JsonConverter<bool, dynamic> {
  const BoolConverter();

  @override
  bool fromJson(dynamic json) => json == 1 || json == true ? true : false;

  @override
  dynamic toJson(bool object) => object;
}

// class NullableBoolConverter implements JsonConverter<bool?, dynamic> {
//   const NullableBoolConverter();

//   @override
//   bool? fromJson(dynamic json) => json == 0 ? false : true;

//   @override
//   dynamic toJson(bool? object) => object;
// }
