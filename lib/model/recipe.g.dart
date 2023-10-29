// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
      ID: json['ID'] as int,
      user_id: json['user_id'] as int,
      recipe_name: json['recipe_name'] as String,
      menu_image: json['menu_image'] as Uint8List,
    );

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'user_id': instance.user_id,
      'recipe_name': instance.recipe_name,
      'menu_image': const Uint8ListConverter().toJson(instance.menu_image),
    };
