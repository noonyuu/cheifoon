// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_bottle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminBottleImpl _$$AdminBottleImplFromJson(Map<String, dynamic> json) =>
    _$AdminBottleImpl(
      admin_seasoning_id: json['admin_seasoning_id'] as int,
      admin_seasoning_name: json['admin_seasoning_name'] as String,
      admin_tea_second: (json['admin_tea_second'] as num).toDouble(),
      bottleImage: json['bottleImage'] as String? ?? 'assets/images/bottle.png',
    );

Map<String, dynamic> _$$AdminBottleImplToJson(_$AdminBottleImpl instance) =>
    <String, dynamic>{
      'admin_seasoning_id': instance.admin_seasoning_id,
      'admin_seasoning_name': instance.admin_seasoning_name,
      'admin_tea_second': instance.admin_tea_second,
      'bottleImage': instance.bottleImage,
    };
