import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../model/recipe_model.dart';

class RecipeController {
  static final dbHelper = DatabaseHelper.instance;
  static final List<Map<String, dynamic>> _menuTable = []; // メニューテーブル
  static final List<RecipeModel> _menu = []; // メニュー

  static Future<List<RecipeModel>> menuList() async {
    // 初期化
    _menuTable.clear();
    _menu.clear();
    // メニューテーブルの照会
    await _queryMenuTable();
    // レシピデータの取得
    await _initializeRecipe();
    return _menu;
  }

  // メニューテーブルの照会
  static Future<void> _queryMenuTable() async {
    final allRows = await dbHelper.queryMenuTable();
    _menuTable.addAll(allRows);
  }

// メニューデータの取得
  static Future<void> _initializeRecipe() async {
    for (var row in _menuTable) {
      Uint8List imageBytes = row['menu_image'];
      _menu.add(RecipeModel(
        recipeId: row['menu_id'],
        title: row['menu_name'],
        imagePath: imageBytes,
      ));
    }
  }
}
