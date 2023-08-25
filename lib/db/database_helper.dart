import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "sazikagen.db"; // データベース名
  static final _databaseVersion = 1; // スキーマのバージョン指定

  static final recipeTable = 'recipe'; // レシピテーブル
  static final seasoningTable = 'seasoning'; // 調味料テーブル名
  static final menuTable = 'menu'; // メニューテーブル名
  static final adminSeasoning = 'admin_seasoning'; // 準備され得ている調味料

  // レシピ表
  static final tableSpoon = 'table_spoon';
  static final teaSpoon = 'tea_spoon';
  // 調味料表
  static final seasoningId = 'seasoning_id';
  static final seasoningName = 'seasoning_name';
  static final teaSecond = 'tea_second';
  // メニュー表
  static final menuId = 'menu_id';
  static final menuName = 'menu_name';
  static final menuImage = 'menu_image';
  // 準備され得ている調味料
  static final ASeasoningId = 'ASeasoningId';
  static final ASeasoningName = 'ASeasoningName';
  static final AteaSecond = 'Atea_second';

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
        $ASeasoningId INTEGER PRIMARY KEY AUTOINCREMENT,
        $ASeasoningName TEXT NOT NULL,
        $AteaSecond REAl NOT NULL
      )''');
      // 調味料テーブル
      await db.execute('''CREATE TABLE $seasoningTable (
        $seasoningId INTEGER PRIMARY KEY AUTOINCREMENT,
        $seasoningName TEXT NOT NULL,
        $teaSecond REAL NOT NULL,
        $ASeasoningId INTEGER,
        FOREIGN KEY ($ASeasoningId) REFERENCES $adminSeasoning($ASeasoningId)
      )''');
      // メニューテーブル
      await db.execute('''CREATE TABLE $menuTable (
        $menuId INTEGER PRIMARY KEY AUTOINCREMENT,
        $menuName TEXT NOT NULL,
        $menuImage BLOB NOT NULL
      )''');
      // レシピテーブル
      await db.execute('''CREATE TABLE $recipeTable (
        $menuId INTEGER,
        $seasoningId INTEGER,
        $tableSpoon INTEGER DEFAULT 0,
        $teaSpoon INTEGER DEFAULT 0,
        PRIMARY KEY ($menuId, $seasoningId),
        FOREIGN KEY ($menuId) REFERENCES $menuTable ($menuId),
        FOREIGN KEY ($seasoningId) REFERENCES $seasoningTable ($seasoningId)
      )''');
    } catch (e) {
      print('エラー：$e');
    }
    print('finish');
  }

// menuTable
  Future<int> insertMenu(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(menuTable, row);
  }

// recipeTable
  Future<int> insertRecipe(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(recipeTable, row);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(menuTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    // await db!.query(adminSeasoning);
    // await db.query(seasoningTable);
    // await db.query(recipeTable);
    return await db!.query(seasoningTable);
  }

  Future<List<Map<String, dynamic>>> queryMenuTable() async {
    Database? db = await instance.database;
    return await db!.query(menuTable);
  }
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
  Future<int> inserta(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(menuTable, row);
  }

  Future<int> insertb(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(adminSeasoning, row);
  }

  Future<int> insertc(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(seasoningTable, row);
  }

  // 削除処理
  Future<int> delete() async {
    Database? db = await instance.database;
    await db!.delete(adminSeasoning);
    return await db.delete(seasoningTable);
  }

  Future<List<Map<String, dynamic>>> queryRecipe() async {
    Database? db = await instance.database;
    return await db!.query(recipeTable);
  }

// menutableの最後に追加されたデータを取得
  Future<Map<String, dynamic>?> getMaxMenuIdRecord() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT MAX($menuId) as count FROM $menuTable
  ''');
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // menuTable 引数のidを条件にレコードを取得
  // Future<List<Map<String, dynamic>>>  getRecordById(row) async {
  //   Database? db = await instance.database;
  //   List<Map<String, dynamic>> results = await db!.rawQuery('''
  //   SELECT * FROM $menuTable WHERE $menuId = $row
  // ''');
  //   if (results.isNotEmpty) {
  //     return results;
  //   }
  //   return [];
  // }
  // menuTable 引数のidを条件にレコードを取得
  Future<List<Map<String, dynamic>>> getRecipeInfo(row) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> results = await db!.rawQuery('''
    SELECT * FROM $recipeTable WHERE $menuId = $row
  ''');
    if (results.isNotEmpty) {
      return results;
    }
    return [];
  }
}
