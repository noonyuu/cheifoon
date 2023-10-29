import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:typed_data';

part 'recipe_model.freezed.dart';
part 'recipe_model.g.dart';

class Uint8ListConverter implements JsonConverter<Uint8List, String> {
  const Uint8ListConverter();

  @override
  Uint8List fromJson(String json) {
    // JSON 文字列をデコードして Uint8List に変換
    List<int> intList = json.codeUnits;
    return Uint8List.fromList(intList);
  }

  @override
  String toJson(Uint8List object) {
    // Uint8List を JSON 文字列にエンコード
    List<int> intList = object.toList();
    String jsonString = String.fromCharCodes(intList);
    return jsonString;
  }
}

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required int ID,
    required int user_id,
    required String recipe_name,
    @Uint8ListConverter() required Uint8List menu_image,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
