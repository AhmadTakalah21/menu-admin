// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_pass_quest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgetPassQuestModel _$ForgetPassQuestModelFromJson(
        Map<String, dynamic> json) =>
    ForgetPassQuestModel(
      method: (json['method'] as num?)?.toInt() ?? 0,
      restaurantId:
          json['restaurant_id'] as String? ?? AppConstants.restaurantId,
      username: json['username'] as String?,
      question: (json['question'] as num?)?.toInt(),
      answer: json['answer'] as String?,
    );

Map<String, dynamic> _$ForgetPassQuestModelToJson(
        ForgetPassQuestModel instance) =>
    <String, dynamic>{
      'method': instance.method,
      'restaurant_id': instance.restaurantId,
      'username': instance.username,
      'question': instance.question,
      'answer': instance.answer,
    };
