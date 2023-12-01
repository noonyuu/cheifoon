import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../model/user_bottle/user_bottle_model.dart';

// userがセットした調味料コントローラー
class BottleController {
  static final dbHelper = DatabaseHelper.instance;
  static final List<Map<String, dynamic>> _bottleTable = [];
  static final List<UserBottle> _bottle = [];

  static List<UserBottle> get bottleLists => _bottle;

  static Future<List<UserBottle>> bottleList() async {
    // 初期化
    _bottleTable.clear();
    _bottle.clear();
    // 調味料テーブルの照会
    await _queryBottleTable();
    await _initializeBottle();
    return _bottle;
  }

  // 調味料テーブルの照会
  static Future<void> _queryBottleTable() async {
    final allRows = await dbHelper.querySeasoningTable();
    _bottleTable.addAll(allRows);
    print('_bottleTable: $_bottleTable');
  }

  // 調味料の初期化
  static Future<void> _initializeBottle() async {
    _bottleTable.forEach((buttle) {
      _bottle.add(UserBottle.fromJson(buttle));
    });
  }

  map(DropdownMenuItem<UserBottle> Function(dynamic bottle) param0) {}
}
