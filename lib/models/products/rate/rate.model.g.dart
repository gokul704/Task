// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateModel _$RateModelFromJson(Map<String, dynamic> json) => RateModel(
      (json['rate'] as num?)?.toDouble(),
      (json['count'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RateModelToJson(RateModel instance) => <String, dynamic>{
      'rate': instance.rate,
      'count': instance.count,
    };
