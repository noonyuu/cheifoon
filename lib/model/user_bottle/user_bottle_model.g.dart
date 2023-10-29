// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bottle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserBottleImpl _$$UserBottleImplFromJson(Map<String, dynamic> json) =>
    _$UserBottleImpl(
      seasoning_id: json['seasoning_id'] as int,
      seasoning_name: json['seasoning_name'] as String,
      tea_second: (json['tea_second'] as num).toDouble(),
      bottleImage: json['bottleImage'] as String? ?? 'assets/images/bottle.png',
    );

Map<String, dynamic> _$$UserBottleImplToJson(_$UserBottleImpl instance) =>
    <String, dynamic>{
      'seasoning_id': instance.seasoning_id,
      'seasoning_name': instance.seasoning_name,
      'tea_second': instance.tea_second,
      'bottleImage': instance.bottleImage,
    };
