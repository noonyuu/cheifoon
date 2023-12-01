import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_bottle_model.freezed.dart';
part 'user_bottle_model.g.dart';

@freezed
class UserBottle with _$UserBottle {
  const factory UserBottle({
    required int seasoning_id,
    required String seasoning_name,
    required double tea_second,
    @Default('assets/images/bottle.png') String bottleImage,
  }) = _UserBottle;

  factory UserBottle.fromJson(Map<String, dynamic> json) => _$UserBottleFromJson(json);
}
