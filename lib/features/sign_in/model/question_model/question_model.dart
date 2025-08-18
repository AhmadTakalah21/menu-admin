import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'question_model.g.dart';

@JsonSerializable()
@immutable
class QuestionModel implements DropDownItemModel{
   const QuestionModel({
    required this.id,
    required this.question,
  });
  
  @override
  final int id;

  final String question;
  
  @override
  String get displayName => question;

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}
