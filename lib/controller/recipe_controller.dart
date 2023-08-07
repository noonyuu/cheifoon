import '../model/card_model.dart';

class RecipeController {
  final List<CardModel> _recipe = [
    CardModel(
        recipeId: 1,
        title: 'オムライス',
        imagePath: 'assets/images/recipe/recipe1.jpg'),
    CardModel(
        recipeId: 2,
        title: 'ハンバーグ',
        imagePath: 'assets/images/recipe/recipe2.jpg'),
    CardModel(
        recipeId: 3,
        title: 'オムライス',
        imagePath: 'assets/images/recipe/recipe1.jpg'),
    CardModel(
        recipeId: 4,
        title: 'オムライス',
        imagePath: 'assets/images/recipe/recipe2.jpg'),
  ];

  List<CardModel> get recipe => _recipe;
}
