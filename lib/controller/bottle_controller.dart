import '../db/database_helper.dart';
import '../model/bottle_model.dart';
//import '../constant/String_constant.dart';

class BottleController {
  static final dbHelper = DatabaseHelper.instance;
  static List<Map<String, dynamic>> _bottleTable = [];
  static List<BottleModel> _bottle = [];

  static Future<List<BottleModel>> bottleList() async {
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
  // final List<BottleModel> _bottle = [
  //   BottleModel(
  //     bottleId: 1,
  //     bottleTitle: '醤油',
  //   ),
  //   BottleModel(
  //     bottleId: 2,
  //     bottleTitle: 'みりん',
  //   ),
  //   BottleModel(
  //     bottleId: 3,
  //     bottleTitle: 'ごま油',
  //   ),
  //   BottleModel(
  //     bottleId: 4,
  //     bottleTitle: 'めんつゆ',
  //   ),
  //   BottleModel(
  //     bottleId: 5,
  //     bottleTitle: '料理酒',
  //   ),
  //   BottleModel(
  //     bottleId: 6,
  //     bottleTitle: 'ケチャップ',
  //   ),
  //   BottleModel(
  //     bottleId: 7,
  //     bottleTitle: 'ポン酢',
  //   ),
  //   BottleModel(
  //     bottleId: 8,
  //     bottleTitle: '醤油',
  //   ),
  // ];

  // List<BottleModel> get bottle => _bottle;
}
