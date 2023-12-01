// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_bottle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AdminBottle _$AdminBottleFromJson(Map<String, dynamic> json) {
  return _AdminBottle.fromJson(json);
}

/// @nodoc
mixin _$AdminBottle {
  int get admin_seasoning_id => throw _privateConstructorUsedError;
  String get admin_seasoning_name => throw _privateConstructorUsedError;
  double get admin_tea_second => throw _privateConstructorUsedError;
  String get bottleImage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminBottleCopyWith<AdminBottle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminBottleCopyWith<$Res> {
  factory $AdminBottleCopyWith(
          AdminBottle value, $Res Function(AdminBottle) then) =
      _$AdminBottleCopyWithImpl<$Res, AdminBottle>;
  @useResult
  $Res call(
      {int admin_seasoning_id,
      String admin_seasoning_name,
      double admin_tea_second,
      String bottleImage});
}

/// @nodoc
class _$AdminBottleCopyWithImpl<$Res, $Val extends AdminBottle>
    implements $AdminBottleCopyWith<$Res> {
  _$AdminBottleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? admin_seasoning_id = null,
    Object? admin_seasoning_name = null,
    Object? admin_tea_second = null,
    Object? bottleImage = null,
  }) {
    return _then(_value.copyWith(
      admin_seasoning_id: null == admin_seasoning_id
          ? _value.admin_seasoning_id
          : admin_seasoning_id // ignore: cast_nullable_to_non_nullable
              as int,
      admin_seasoning_name: null == admin_seasoning_name
          ? _value.admin_seasoning_name
          : admin_seasoning_name // ignore: cast_nullable_to_non_nullable
              as String,
      admin_tea_second: null == admin_tea_second
          ? _value.admin_tea_second
          : admin_tea_second // ignore: cast_nullable_to_non_nullable
              as double,
      bottleImage: null == bottleImage
          ? _value.bottleImage
          : bottleImage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminBottleImplCopyWith<$Res>
    implements $AdminBottleCopyWith<$Res> {
  factory _$$AdminBottleImplCopyWith(
          _$AdminBottleImpl value, $Res Function(_$AdminBottleImpl) then) =
      __$$AdminBottleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int admin_seasoning_id,
      String admin_seasoning_name,
      double admin_tea_second,
      String bottleImage});
}

/// @nodoc
class __$$AdminBottleImplCopyWithImpl<$Res>
    extends _$AdminBottleCopyWithImpl<$Res, _$AdminBottleImpl>
    implements _$$AdminBottleImplCopyWith<$Res> {
  __$$AdminBottleImplCopyWithImpl(
      _$AdminBottleImpl _value, $Res Function(_$AdminBottleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? admin_seasoning_id = null,
    Object? admin_seasoning_name = null,
    Object? admin_tea_second = null,
    Object? bottleImage = null,
  }) {
    return _then(_$AdminBottleImpl(
      admin_seasoning_id: null == admin_seasoning_id
          ? _value.admin_seasoning_id
          : admin_seasoning_id // ignore: cast_nullable_to_non_nullable
              as int,
      admin_seasoning_name: null == admin_seasoning_name
          ? _value.admin_seasoning_name
          : admin_seasoning_name // ignore: cast_nullable_to_non_nullable
              as String,
      admin_tea_second: null == admin_tea_second
          ? _value.admin_tea_second
          : admin_tea_second // ignore: cast_nullable_to_non_nullable
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
class _$AdminBottleImpl implements _AdminBottle {
  const _$AdminBottleImpl(
      {required this.admin_seasoning_id,
      required this.admin_seasoning_name,
      required this.admin_tea_second,
      this.bottleImage = 'assets/images/bottle.png'});

  factory _$AdminBottleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminBottleImplFromJson(json);

  @override
  final int admin_seasoning_id;
  @override
  final String admin_seasoning_name;
  @override
  final double admin_tea_second;
  @override
  @JsonKey()
  final String bottleImage;

  @override
  String toString() {
    return 'AdminBottle(admin_seasoning_id: $admin_seasoning_id, admin_seasoning_name: $admin_seasoning_name, admin_tea_second: $admin_tea_second, bottleImage: $bottleImage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminBottleImpl &&
            (identical(other.admin_seasoning_id, admin_seasoning_id) ||
                other.admin_seasoning_id == admin_seasoning_id) &&
            (identical(other.admin_seasoning_name, admin_seasoning_name) ||
                other.admin_seasoning_name == admin_seasoning_name) &&
            (identical(other.admin_tea_second, admin_tea_second) ||
                other.admin_tea_second == admin_tea_second) &&
            (identical(other.bottleImage, bottleImage) ||
                other.bottleImage == bottleImage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, admin_seasoning_id,
      admin_seasoning_name, admin_tea_second, bottleImage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminBottleImplCopyWith<_$AdminBottleImpl> get copyWith =>
      __$$AdminBottleImplCopyWithImpl<_$AdminBottleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminBottleImplToJson(
      this,
    );
  }
}

abstract class _AdminBottle implements AdminBottle {
  const factory _AdminBottle(
      {required final int admin_seasoning_id,
      required final String admin_seasoning_name,
      required final double admin_tea_second,
      final String bottleImage}) = _$AdminBottleImpl;

  factory _AdminBottle.fromJson(Map<String, dynamic> json) =
      _$AdminBottleImpl.fromJson;

  @override
  int get admin_seasoning_id;
  @override
  String get admin_seasoning_name;
  @override
  double get admin_tea_second;
  @override
  String get bottleImage;
  @override
  @JsonKey(ignore: true)
  _$$AdminBottleImplCopyWith<_$AdminBottleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
