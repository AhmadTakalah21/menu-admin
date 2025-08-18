import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/global/utils/constants.dart';

part 'forget_pass_quest_model.g.dart';

@JsonSerializable()
@immutable
class ForgetPassQuestModel {
  const ForgetPassQuestModel({
    this.method = 0,
    this.restaurantId = AppConstants.restaurantId,
    String? username,
    int? question,
    String? answer,
  })  : _username = username,
        _question = question,
        _answer = answer;

  final int method;

  final String? _username;

  final int? _question;

  final String? _answer;

  @JsonKey(name: 'restaurant_id')
  final String restaurantId;

  ForgetPassQuestModel copyWith({
    String? username,
    int? question,
    String? answer,
  }) {
    return ForgetPassQuestModel(
      username: username ?? _username,
      question: question ?? _question,
      answer: answer ?? _answer,
    );
  }

  String get username {
    if (_username == null || _username.isEmpty) {
      throw 'Username is required';
    }
    return _username;
  }

  int get question {
    return _question ?? (throw 'Question is required');
  }

  String get answer {
    if (_answer == null || _answer.isEmpty) {
      throw 'Answer is required';
    }
    return _answer;
  }

  Map<String, dynamic> toJson() => _$ForgetPassQuestModelToJson(this);

  factory ForgetPassQuestModel.fromJson(Map<String, dynamic> json) =>
      _$ForgetPassQuestModelFromJson(json);
}
