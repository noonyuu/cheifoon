import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../db/recipe_show.dart';
import '../model/recipe_model.dart';

class RecipeController {
  static List<dynamic> _recipe = []; // メニューテーブル
  static final List<RecipeModel> _menu = []; // メニュー

  static Future<List<RecipeModel>> menuList() async {
    // 初期化
    _recipe.clear();
    _menu.clear();
    // レシピデータの取得
    _recipe = await getRecipe(1);
    // メニューデータの取得
    await _initializeRecipe();
    return _menu;
  }

// メニューデータの取得
  static Future<void> _initializeRecipe() async {
    for (var row in _recipe) {
      _menu.add(RecipeModel(
        recipeId: row['ID'],
        userId: row['user_id'],
        title: row['recipe_name'],
        imagePath: row['menu_image'],
      ));
    }
  }
}
