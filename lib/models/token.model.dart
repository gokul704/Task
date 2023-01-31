import 'package:json_annotation/json_annotation.dart';

part 'token.model.g.dart';

@JsonSerializable()
class TokenModel {
  final String? token;

  TokenModel(this.token);
  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
