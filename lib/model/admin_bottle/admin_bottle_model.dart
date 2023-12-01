import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_bottle_model.freezed.dart';
part 'admin_bottle_model.g.dart';

@freezed
class AdminBottle with _$AdminBottle {
  const factory AdminBottle({
    required int admin_seasoning_id,
    required String admin_seasoning_name,
    required double admin_tea_second,
    @Default('assets/images/bottle.png') String bottleImage,
  }) = _AdminBottle;

  factory AdminBottle.fromJson(Map<String, dynamic> json) => _$AdminBottleFromJson(json);
}
