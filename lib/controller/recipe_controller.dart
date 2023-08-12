import '../model/recipe_model.dart';

class RecipeController {
  final List<RecipeModel> _recipe = [
    RecipeModel(recipeId: 1, title: 'オムライス', imagePath: 'assets/images/recipe/sample/recipe1.jpg'),
    RecipeModel(recipeId: 2, title: 'ハンバーグ', imagePath: 'assets/images/recipe/sample/recipe2.jpg'),
    RecipeModel(recipeId: 3, title: 'オムライス', imagePath: 'assets/images/recipe/sample/recipe1.jpg'),
    RecipeModel(recipeId: 4, title: 'オムライス', imagePath: 'assets/images/recipe/sample/recipe2.jpg'),
    RecipeModel(recipeId: 4, title: 'オムライス', imagePath: 'assets/images/recipe/sample/recipe2.jpg'),
    RecipeModel(recipeId: 4, title: 'オムライス', imagePath: 'assets/images/recipe/sample/recipe2.jpg'),
    RecipeModel(recipeId: 4, title: 'オムライス', imagePath: 'assets/images/recipe/sample/recipe2.jpg'),
    RecipeModel(recipeId: 4, title: 'オムライス', imagePath: 'assets/images/recipe/sample/recipe2.jpg'),
  ];

  List<RecipeModel> get recipe => _recipe;
}