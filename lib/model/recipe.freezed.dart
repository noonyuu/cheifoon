// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return _Recipe.fromJson(json);
}

/// @nodoc
mixin _$Recipe {
  int get ID => throw _privateConstructorUsedError;
  int get user_id => throw _privateConstructorUsedError;
  String get recipe_name => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List get menu_image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecipeCopyWith<Recipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeCopyWith<$Res> {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) then) =
      _$RecipeCopyWithImpl<$Res, Recipe>;
  @useResult
  $Res call(
      {int ID,
      int user_id,
      String recipe_name,
      @Uint8ListConverter() Uint8List menu_image});
}

/// @nodoc
class _$RecipeCopyWithImpl<$Res, $Val extends Recipe>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ID = null,
    Object? user_id = null,
    Object? recipe_name = null,
    Object? menu_image = null,
  }) {
    return _then(_value.copyWith(
      ID: null == ID
          ? _value.ID
          : ID // ignore: cast_nullable_to_non_nullable
              as int,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as int,
      recipe_name: null == recipe_name
          ? _value.recipe_name
          : recipe_name // ignore: cast_nullable_to_non_nullable
              as String,
      menu_image: null == menu_image
          ? _value.menu_image
          : menu_image // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeImplCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$$RecipeImplCopyWith(
          _$RecipeImpl value, $Res Function(_$RecipeImpl) then) =
      __$$RecipeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int ID,
      int user_id,
      String recipe_name,
      @Uint8ListConverter() Uint8List menu_image});
}

/// @nodoc
class __$$RecipeImplCopyWithImpl<$Res>
    extends _$RecipeCopyWithImpl<$Res, _$RecipeImpl>
    implements _$$RecipeImplCopyWith<$Res> {
  __$$RecipeImplCopyWithImpl(
      _$RecipeImpl _value, $Res Function(_$RecipeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ID = null,
    Object? user_id = null,
    Object? recipe_name = null,
    Object? menu_image = null,
  }) {
    return _then(_$RecipeImpl(
      ID: null == ID
          ? _value.ID
          : ID // ignore: cast_nullable_to_non_nullable
              as int,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as int,
      recipe_name: null == recipe_name
          ? _value.recipe_name
          : recipe_name // ignore: cast_nullable_to_non_nullable
              as String,
      menu_image: null == menu_image
          ? _value.menu_image
          : menu_image // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeImpl implements _Recipe {
  const _$RecipeImpl(
      {required this.ID,
      required this.user_id,
      required this.recipe_name,
      @Uint8ListConverter() required this.menu_image});

  factory _$RecipeImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeImplFromJson(json);

  @override
  final int ID;
  @override
  final int user_id;
  @override
  final String recipe_name;
  @override
  @Uint8ListConverter()
  final Uint8List menu_image;

  @override
  String toString() {
    return 'Recipe(ID: $ID, user_id: $user_id, recipe_name: $recipe_name, menu_image: $menu_image)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeImpl &&
            (identical(other.ID, ID) || other.ID == ID) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.recipe_name, recipe_name) ||
                other.recipe_name == recipe_name) &&
            const DeepCollectionEquality()
                .equals(other.menu_image, menu_image));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ID, user_id, recipe_name,
      const DeepCollectionEquality().hash(menu_image));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      __$$RecipeImplCopyWithImpl<_$RecipeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeImplToJson(
      this,
    );
  }
}

abstract class _Recipe implements Recipe {
  const factory _Recipe(
          {required final int ID,
          required final int user_id,
          required final String recipe_name,
          @Uint8ListConverter() required final Uint8List menu_image}) =
      _$RecipeImpl;

  factory _Recipe.fromJson(Map<String, dynamic> json) = _$RecipeImpl.fromJson;

  @override
  int get ID;
  @override
  int get user_id;
  @override
  String get recipe_name;
  @override
  @Uint8ListConverter()
  Uint8List get menu_image;
  @override
  @JsonKey(ignore: true)
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
