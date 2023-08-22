import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../model/recipe_model.dart';

class RecipeController {
  static final dbHelper = DatabaseHelper.instance;
  static List<Map<String, dynamic>> _menuTable = [];
  static List<RecipeModel> _recipe = [];

  static Future<List<RecipeModel>> menuList() async {
    await _queryMenuTable();
    await _initializeRecipe();
    return _recipe;
  }

  // メニューテーブルの照会
  static Future<void> _queryMenuTable() async {
    final allRows = await dbHelper.queryMenuTable();
    _menuTable.addAll(allRows);
  }

  // レシピの初期化
  static Future<void> _initializeRecipe() async {
    for (var row in _menuTable) {
      Uint8List imageBytes = row['menu_image'];
      _recipe.add(RecipeModel(
        recipeId: row['menu_id'],
        title: row['menu_name'],
        imagePath: imageBytes, // バイト配列を画像に変換
      ));
    }
  }
}
