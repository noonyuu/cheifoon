import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../model/admin_bottle/admin_bottle_model.dart';


class BottleAdminController {
  static final dbHelper = DatabaseHelper.instance;
  static final List<Map<String, dynamic>> _bottleTable = [];
  static final List<AdminBottle> _bottle = [];

  static List<AdminBottle> get bottleAdminLists => _bottle;

  static Future<List<AdminBottle>> bottleList() async {
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
      final shouldRemove = check.any((removeItem) => removeItem['admin_seasoning_id'] == element['admin_seasoning_id']);
      if (shouldRemove) {
        if (kDebugMode) print('Removing element with admin_seasoningId ${element['admin_seasoning_id']}');
      }
      return shouldRemove;
    });
    if (kDebugMode) print('_bottleTable (after removal): $_bottleTable');
  }

  // 調味料の初期化
  static Future<void> _initializeBottle() async {
    _bottleTable.forEach((bottle) {
      _bottle.add(AdminBottle.fromJson(bottle));
    });
  }

  map(DropdownMenuItem<AdminBottle> Function(dynamic bottle) param0) {}
}
