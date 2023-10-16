import 'dart:typed_data';

class RecipeModel {
  final int recipeId;
  final int userId;
  final String title;
  final String imagePath;

  RecipeModel(
      {required this.recipeId,required this.userId, required this.title, required this.imagePath});
}
