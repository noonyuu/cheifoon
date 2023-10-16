import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "cheifoon.db"; // データベース名
  static const _databaseVersion = 1; // スキーマのバージョン指定

  // static const recipeTable = 'recipe'; // レシピテーブル
  // static const menuTable = 'menu'; // メニューテーブル名
  static const seasoningTable = 'seasoning'; // 調味料テーブル名
  static const adminSeasoning = 'admin_seasoning'; // 準備され得ている調味料

  // // レシピ表
  // static const tableSpoon = 'table_spoon';
  // static const teaSpoon = 'tea_spoon';
  //   // メニュー表
  // static const menuId = 'menu_id';
  // static const menuName = 'menu_name';
  // static const menuImage = 'menu_image';

  // 準備され得ている調味料
  static const adminSeasoningId = 'admin_seasoningId';
  static const adminSeasoningName = 'admin_seasoningName';
  static const adminTeaSecond = 'admin_teaSecond';

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

    // PRAGMA文を実行する代わりにrawQueryを使用
    await db.rawQuery('PRAGMA max_page_count = 2147483646;');

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
      await db.execute('''INSERT INTO $adminSeasoning ($adminSeasoningName, $adminTeaSecond) VALUES('さけ', 1.2)''');
      await db.execute('''INSERT INTO $adminSeasoning ($adminSeasoningName, $adminTeaSecond) VALUES('ウスターソース', 1.2)''');
      // 調味料テーブル
      await db.execute('''CREATE TABLE $seasoningTable (
        $seasoningId INTEGER PRIMARY KEY AUTOINCREMENT,
        $seasoningName TEXT NOT NULL,
        $teaSecond REAL NOT NULL,
        $adminSeasoningId INTEGER,
        FOREIGN KEY ($adminSeasoningId) REFERENCES $adminSeasoning($adminSeasoningId)
      )''');
      // メニューテーブル
      // await db.execute('''CREATE TABLE $menuTable (
      //   $menuId INTEGER PRIMARY KEY AUTOINCREMENT,
      //   $menuName TEXT NOT NULL,
      //   $menuImage BLOB NOT NULL
      // )''');
      // レシピテーブル
      // await db.execute('''CREATE TABLE $recipeTable (
      //   $menuId INTEGER,
      //   $seasoningId INTEGER,
      //   $tableSpoon INTEGER DEFAULT 0,
      //   $teaSpoon INTEGER DEFAULT 0,
      //   PRIMARY KEY ($menuId, $seasoningId),
      //   FOREIGN KEY ($menuId) REFERENCES $menuTable ($menuId),
      //   FOREIGN KEY ($seasoningId) REFERENCES $seasoningTable ($seasoningId)
      // )''');
      // TODO: テストデータ
      // Uint8List curry = (await rootBundle.load('assets/images/recipe/sample/curry.png')).buffer.asUint8List();
      // Uint8List OmeletteRice = (await rootBundle.load('assets/images/recipe/sample/OmeletteRice.png')).buffer.asUint8List();
      // await db.rawInsert('''INSERT INTO $menuTable ($menuName, $menuImage) VALUES (?, ?)''', ['カレー', curry]);
      // await db.rawInsert('''INSERT INTO $menuTable ($menuName, $menuImage) VALUES (?, ?)''', ['オムライス', OmeletteRice]);

      // await db.execute('''INSERT INTO $recipeTable ($menuId, $seasoningId,$tableSpoon,$teaSpoon) VALUES (?,?,?,?)''', [1, 1, 0, 1]);
      // await db.execute('''INSERT INTO $recipeTable ($menuId, $seasoningId,$tableSpoon,$teaSpoon) VALUES (?,?,?,?)''', [1, 4, 1, 0]); // カレー,醤油,0,1,ウスターソース,1,1
      // await db.execute('''INSERT INTO $recipeTable ($menuId, $seasoningId,$tableSpoon,$teaSpoon) VALUES(?,?,?,?)''', [2, 4, 0, 2]);
    } catch (e) {
      print('エラー：$e');
    }
    print('finish');
  }

// menuTable
  // Future<int> insertMenu(Map<String, dynamic> row) async {
  //   Database? db = await instance.database;
  //   return await db!.insert(menuTable, row);
  // }

// recipeTable
  // Future<int> insertRecipe(Map<String, dynamic> row) async {
  //   Database? db = await instance.database;
  //   return await db!.insert(recipeTable, row);
  // }

  // Future<int> insert(Map<String, dynamic> row) async {
  //   Database? db = await instance.database;
  //   return await db!.insert(menuTable, row);
  // }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(seasoningTable);
  }

// menuTableの全レコードを取得
  // Future<List<Map<String, dynamic>>> queryMenuTable() async {
  //   Database? db = await instance.database;
  //   return await db!.query(menuTable);
  // }

  Future<List<Map<String, dynamic>>> queryAdminSeasoningTable() async {
    Database? db = await instance.database;
    return await db!.query(adminSeasoning);
  }

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

  // test data
  // Future<int> inserta(Map<String, dynamic> row) async {
  //   Database? db = await instance.database;
  //   return await db!.insert(menuTable, row);
  // }

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

// データベースから削除する行を取得する
  //   List<Map<String, dynamic>> rowsToDelete = await db.query(recipeTable, where: '$seasoningId = ?', whereArgs: [bottleId]);

  //   if (rowsToDelete.isNotEmpty) {
  //     for (final row in rowsToDelete) {
  //       int id = row[menuId];
  //       deletedIds.add(id); // 削除された行のIDをリストに追加
  //     }
  //     // データベースから指定したIDの行を削除
  //     await db.delete(recipeTable, where: '$seasoningId = ?', whereArgs: [bottleId]);
  //     for (int i = 0; i < deletedIds.length; i++) {
  //       await db.delete(menuTable, where: '$menuId = ?', whereArgs: [deletedIds[i]]);
  //     }
  //   }
  // }

  // Future<List<Map<String, dynamic>>> queryRecipe() async {
  //   Database? db = await instance.database;
  //   return await db!.query(recipeTable);
  // }

// menutableの最後に追加されたデータを取得
  // Future<Map<String, dynamic>?> getMaxMenuIdRecord() async {
  //   Database? db = await instance.database;
  //   List<Map<String, dynamic>> results = await db!.rawQuery('''
  //   SELECT MAX($menuId) as count FROM $menuTable
  // ''');
  //   if (results.isNotEmpty) {
  //     return results.first;
  //   }
  //   return null;
  // }

  // menuTable 引数のidを条件にレコードを取得
  // Future<List<Map<String, dynamic>>> getRecipeInfo(row) async {
  //   Database? db = await instance.database;
  //   List<Map<String, dynamic>> results = await db!.rawQuery('''
  //   SELECT * FROM $recipeTable WHERE $menuId = $row
  // ''');
  //   if (results.isNotEmpty) {
  //     return results;
  //   }
  //   return [];
  // }

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
