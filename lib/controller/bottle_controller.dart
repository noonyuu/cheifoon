import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';

import '../db/database_helper.dart';
import '../model/bottle_model.dart';
//import '../constant/String_constant.dart';

class BottleController {
  static final dbHelper = DatabaseHelper.instance;
  static List<Map<String, dynamic>> _bottleTable = [];
  static List<BottleModel> _bottle = [];

  static List<BottleModel> get bottleLists => _bottle;

  static Future<List<BottleModel>> bottleList() async {
    _bottleTable.clear();
    _bottle.clear();
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
      ));
    }
  }

  map(DropdownMenuItem<BottleModel> Function(dynamic bottle) param0) {}
}

class BottleAdminController {
  static final dbHelper = DatabaseHelper.instance;
  static List<Map<String, dynamic>> _bottleTable = [];
  static List<BottleAdminModel> _bottle = [];

  static List<BottleAdminModel> get bottleadminLists => _bottle;

  static Future<List<BottleAdminModel>> bottleList() async {
    _bottleTable.clear();
    _bottle.clear();
    await _queryBottleTable();
    await _initializeBottle();
    return _bottle;
  }

  // 調味料テーブルの照会
  static Future<void> _queryBottleTable() async {
    final allRows = await dbHelper.queryAdminSeasoningTable();
    final Check = await dbHelper.getSeasoningInfo();

    _bottleTable.addAll(allRows);

    _bottleTable.removeWhere((element) => Check.any((removeItem) => removeItem['ASeasoningId'] == element['ASeasoningId']));
    print(_bottleTable);
  }

  // 調味料の初期化
  static Future<void> _initializeBottle() async {
    for (var row in _bottleTable) {
      _bottle.add(BottleAdminModel(
        bottleId: row['ASeasoningId'],
        bottleTitle: row['ASeasoningName'],
      ));
    }
  }

  map(DropdownMenuItem<BottleAdminModel> Function(dynamic bottle) param0) {}
}
