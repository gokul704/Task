import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
part 'rate.model.g.dart';

@JsonSerializable()
class RateModel {
  final double? rate;
  final double? count;

  RateModel(this.rate, this.count);

  factory RateModel.fromJson(Map<String, dynamic> json) =>
      _$RateModelFromJson(json);

  Map<String, dynamic> toJson() => _$RateModelToJson(this);
}
