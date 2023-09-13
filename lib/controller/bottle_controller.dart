import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../model/bottle_model.dart';

// userがセットした調味料コントローラー
class BottleController {
  static final dbHelper = DatabaseHelper.instance;
  static final List<Map<String, dynamic>> _bottleTable = [];
  static final List<BottleModel> _bottle = [];

  static List<BottleModel> get bottleLists => _bottle;

  static Future<List<BottleModel>> bottleList() async {
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
  }

  // 調味料の初期化
  static Future<void> _initializeBottle() async {
    for (var row in _bottleTable) {
      _bottle.add(BottleModel(
        bottleId: row['seasoning_id'],
        bottleTitle: row['seasoning_name'],
        teaSecond: row['tea_second'],
      ));
    }
  }

  map(DropdownMenuItem<BottleModel> Function(dynamic bottle) param0) {}
}

// adminがセットした調味料コントローラー
class BottleAdminController {
  static final dbHelper = DatabaseHelper.instance;
  static final List<Map<String, dynamic>> _bottleTable = [];
  static final List<BottleAdminModel> _bottle = [];

  static List<BottleAdminModel> get bottleAdminLists => _bottle;

  static Future<List<BottleAdminModel>> bottleList() async {
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
    final allRows = await dbHelper.queryAdminSeasoningTable();
    final check = await dbHelper.getSeasoningInfo();

    _bottleTable.addAll(allRows);
    _bottleTable.removeWhere((element) {
      final shouldRemove = check.any((removeItem) => removeItem['ASeasoningId'] == element['ASeasoningId']);
      if (shouldRemove) {
        if (kDebugMode) print('Removing element with ASeasoningId ${element['ASeasoningId']}');
      }
      return shouldRemove;
    });
    if (kDebugMode) print('_bottleTable (after removal): $_bottleTable');
  }

  // 調味料の初期化
  static Future<void> _initializeBottle() async {
    for (var row in _bottleTable) {
      _bottle.add(BottleAdminModel(
        bottleId: row['ASeasoningId'],
        bottleTitle: row['ASeasoningName'],
        teaSecond: row['Atea_second'],
      ));
    }
  }

  map(DropdownMenuItem<BottleAdminModel> Function(dynamic bottle) param0) {}
}
