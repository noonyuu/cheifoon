// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_bottle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserBottle _$UserBottleFromJson(Map<String, dynamic> json) {
  return _UserBottle.fromJson(json);
}

/// @nodoc
mixin _$UserBottle {
  int get seasoning_id => throw _privateConstructorUsedError;
  String get seasoning_name => throw _privateConstructorUsedError;
  double get tea_second => throw _privateConstructorUsedError;
  String get bottleImage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserBottleCopyWith<UserBottle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBottleCopyWith<$Res> {
  factory $UserBottleCopyWith(
          UserBottle value, $Res Function(UserBottle) then) =
      _$UserBottleCopyWithImpl<$Res, UserBottle>;
  @useResult
  $Res call(
      {int seasoning_id,
      String seasoning_name,
      double tea_second,
      String bottleImage});
}

/// @nodoc
class _$UserBottleCopyWithImpl<$Res, $Val extends UserBottle>
    implements $UserBottleCopyWith<$Res> {
  _$UserBottleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seasoning_id = null,
    Object? seasoning_name = null,
    Object? tea_second = null,
    Object? bottleImage = null,
  }) {
    return _then(_value.copyWith(
      seasoning_id: null == seasoning_id
          ? _value.seasoning_id
          : seasoning_id // ignore: cast_nullable_to_non_nullable
              as int,
      seasoning_name: null == seasoning_name
          ? _value.seasoning_name
          : seasoning_name // ignore: cast_nullable_to_non_nullable
              as String,
      tea_second: null == tea_second
          ? _value.tea_second
          : tea_second // ignore: cast_nullable_to_non_nullable
              as double,
      bottleImage: null == bottleImage
          ? _value.bottleImage
          : bottleImage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserBottleImplCopyWith<$Res>
    implements $UserBottleCopyWith<$Res> {
  factory _$$UserBottleImplCopyWith(
          _$UserBottleImpl value, $Res Function(_$UserBottleImpl) then) =
      __$$UserBottleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int seasoning_id,
      String seasoning_name,
      double tea_second,
      String bottleImage});
}

/// @nodoc
class __$$UserBottleImplCopyWithImpl<$Res>
    extends _$UserBottleCopyWithImpl<$Res, _$UserBottleImpl>
    implements _$$UserBottleImplCopyWith<$Res> {
  __$$UserBottleImplCopyWithImpl(
      _$UserBottleImpl _value, $Res Function(_$UserBottleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seasoning_id = null,
    Object? seasoning_name = null,
    Object? tea_second = null,
    Object? bottleImage = null,
  }) {
    return _then(_$UserBottleImpl(
      seasoning_id: null == seasoning_id
          ? _value.seasoning_id
          : seasoning_id // ignore: cast_nullable_to_non_nullable
              as int,
      seasoning_name: null == seasoning_name
          ? _value.seasoning_name
          : seasoning_name // ignore: cast_nullable_to_non_nullable
              as String,
      tea_second: null == tea_second
          ? _value.tea_second
          : tea_second // ignore: cast_nullable_to_non_nullable
              as double,
      bottleImage: null == bottleImage
          ? _value.bottleImage
          : bottleImage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBottleImpl implements _UserBottle {
  const _$UserBottleImpl(
      {required this.seasoning_id,
      required this.seasoning_name,
      required this.tea_second,
      this.bottleImage = 'assets/images/bottle.png'});

  factory _$UserBottleImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBottleImplFromJson(json);

  @override
  final int seasoning_id;
  @override
  final String seasoning_name;
  @override
  final double tea_second;
  @override
  @JsonKey()
  final String bottleImage;

  @override
  String toString() {
    return 'UserBottle(seasoning_id: $seasoning_id, seasoning_name: $seasoning_name, tea_second: $tea_second, bottleImage: $bottleImage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBottleImpl &&
            (identical(other.seasoning_id, seasoning_id) ||
                other.seasoning_id == seasoning_id) &&
            (identical(other.seasoning_name, seasoning_name) ||
                other.seasoning_name == seasoning_name) &&
            (identical(other.tea_second, tea_second) ||
                other.tea_second == tea_second) &&
            (identical(other.bottleImage, bottleImage) ||
                other.bottleImage == bottleImage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, seasoning_id, seasoning_name, tea_second, bottleImage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBottleImplCopyWith<_$UserBottleImpl> get copyWith =>
      __$$UserBottleImplCopyWithImpl<_$UserBottleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBottleImplToJson(
      this,
    );
  }
}

abstract class _UserBottle implements UserBottle {
  const factory _UserBottle(
      {required final int seasoning_id,
      required final String seasoning_name,
      required final double tea_second,
      final String bottleImage}) = _$UserBottleImpl;

  factory _UserBottle.fromJson(Map<String, dynamic> json) =
      _$UserBottleImpl.fromJson;

  @override
  int get seasoning_id;
  @override
  String get seasoning_name;
  @override
  double get tea_second;
  @override
  String get bottleImage;
  @override
  @JsonKey(ignore: true)
  _$$UserBottleImplCopyWith<_$UserBottleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
