import '../db/recipe_show.dart';
import '../model/recipe/recipe_model.dart';

class RecipeController {
  static List<dynamic> _recipe = [];    // メニューテーブル
  static final List<Recipe> _menu = []; // メニュー

  static Future<List<Recipe>> menuList() async {
    // 初期化
    _recipe.clear();
    _menu.clear();
    // レシピデータの取得
    // TODO: UserIDを引数にする
    _recipe = await getRecipe(1);
    // メニューデータの取得
    await _initializeRecipe();
    return _menu;
  }

// メニューデータの取得
  static Future<void> _initializeRecipe() async {
    _recipe.forEach((user) {
      _menu.add(Recipe.fromJson(user));
    });
  }
}
