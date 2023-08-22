import 'dart:typed_data';

class RecipeModel {
  final int recipeId;
  final String title;
  final Uint8List imagePath;

  RecipeModel(
      {required this.recipeId, required this.title, required this.imagePath});
}
