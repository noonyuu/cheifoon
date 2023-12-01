import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "cheifoon.db"; // データベース名
  static const _databaseVersion = 1; // スキーマのバージョン指定

  static const seasoningTable = 'seasoning'; // 調味料テーブル名
  static const adminSeasoning = 'admin_seasoning'; // 準備され得ている調味料

  // 準備され得ている調味料
  static const adminSeasoningId = 'admin_seasoning_id';
  static const adminSeasoningName = 'admin_seasoning_name';
  static const adminTeaSecond = 'admin_tea_second';

  // 調味料表
  static const seasoningId = 'seasoning_id';
  static const seasoningName = 'seasoning_name';
  static const teaSecond = 'tea_second';

  // DatabaseHelper クラスを定義
  DatabaseHelper._privateConstructor();
  // DatabaseHelper クラスのインスタンスは、常に同じものであるという保証
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  // Databaseクラス型のstatic変数_databaseを宣言
  // クラスはインスタンス化しない
  static Database? _database;

  // databaseメソッド定義
  Future<Database?> get database async {
    // _databaseがNULLか判定してNULLの場合は_initDatabaseを呼び出してデータベースを初期化し、_databaseに返す
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    Database db = await openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: (Database db) async {
        // 何も実行しない
      },
      onCreate: _onCreate,
    );
    return db;
  }

  // テーブル作成メソッド
  Future _onCreate(Database db, int version) async {
    // 準備され得ている調味料
    try {
      await db.execute("PRAGMA foreign_keys = ON");
      await db.execute('''CREATE TABLE $adminSeasoning (
        $adminSeasoningId INTEGER PRIMARY KEY AUTOINCREMENT,
        $adminSeasoningName TEXT NOT NULL,
        $adminTeaSecond REAl NOT NULL
      )''');
      // admin追加
      await db.execute('''INSERT INTO $adminSeasoning ($adminSeasoningName, $adminTeaSecond) VALUES('醤油', 1.2)''');
      await db.execute('''INSERT INTO $adminSeasoning ($adminSeasoningName, $adminTeaSecond) VALUES('みりん', 1.2)''');
      // await db.execute('''INSERT INTO $adminSeasoning ($adminSeasoningName, $adminTeaSecond) VALUES('さけ', 1.2)''');
      await db.execute('''INSERT INTO $adminSeasoning ($adminSeasoningName, $adminTeaSecond) VALUES('ウスターソース', 1.2)''');
      // 調味料テーブル
      await db.execute('''CREATE TABLE $seasoningTable (
        $seasoningId INTEGER PRIMARY KEY AUTOINCREMENT,
        $seasoningName TEXT NOT NULL,
        $teaSecond REAL NOT NULL,
        $adminSeasoningId INTEGER,
        FOREIGN KEY ($adminSeasoningId) REFERENCES $adminSeasoning($adminSeasoningId)
      )''');
    } catch (e) {
      print('エラー：$e');
    }
    print('finish');
  }

  // Future<List<Map<String, dynamic>>> querySeasoning() async {
  //   Database? db = await instance.database;
  //   return await db!.query(seasoningTable);
  // }

  // 登録されている調味料を全取得
  Future<List<Map<String, dynamic>>> queryAdminSeasoningTable() async {
    Database? db = await instance.database;
    return await db!.query(adminSeasoning);
  }

  // 調味料テーブルを全取得
  Future<List<Map<String, dynamic>>> querySeasoningTable() async {
    Database? db = await instance.database;
    return await db!.query(seasoningTable);
  }

  Future<List<Map<String, dynamic>>> querySeasoningId(String id) async {
    Database? db = await instance.database;
    return await db!.rawQuery('''
    SELECT seasoning_name FROM $seasoningTable WHERE seasoning_id = $id
    ''');
  }

  Future<int> insertb(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(adminSeasoning, row);
  }

// userがセットした調味料を追加
  Future<int> insertSeasoning(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(seasoningTable, row);
  }

  // 削除処理
  Future<void> deleteBottle(int bottleId) async {
    Database? db = await instance.database;
    await db!.delete(seasoningTable, where: '$seasoningId = ?', whereArgs: [bottleId]);
    // 削除した調味料を含むレシピとメニューを削除
    // 削除された行のIDを保存するリスト
    List<int> deletedIds = [];
  }

  // seasoningですでに追加されてるか確認
  Future<List<Map<String, dynamic>>> getSeasoningInfo() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT $adminSeasoningId FROM $adminSeasoning WHERE $adminSeasoningId in (SELECT $seasoningId FROM $seasoningTable)
  ''');
    if (results.isNotEmpty) {
      return results;
    }
    return [];
  }
}
