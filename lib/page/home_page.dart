import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../component/appbar.dart';
import 'addalert.dart';
import '../constant/String_constant.dart';
import 'package:sazikagen/model/bottle_model.dart';
import '../db/database_helper.dart';
import '../model/recipe_model.dart';
import '../controller/recipe_controller.dart';
import '../controller/bottle_controller.dart';
import '../component/card.dart';
import '../component/bottle.dart';

import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> _recipepost = [];
  List<BottleModel> _bottlepost = [];
  List<Map<String, dynamic>> _queryResult = [];
  final dbHelper = DatabaseHelper.instance;
  bool isMenuLoding = true;
  bool isBottleLoding = true;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    // TODO: コメントアウト４行はずして読み込めばSQLiteにデータが入るけど、もどしわすれないように(test配置なので毎回読み込むたびにinsertされます)
    // _insert(); //オムライス
    // _inserta(); //ハンバーグ
    // _insertb(); //a_醤油
    // _insertc(); //醤油

    // test：調味料のデータを削除するときに使う
    // _delete();
    await RecipeController.menuList().then((menuList) {
      _query();
      setState(() {
        _recipepost = menuList;
        isMenuLoding = false;
      });
    }); // RecipeControllerからデータを取得
    await BottleController.bottleList().then((bottleList) {
      setState(() {
        _bottlepost = bottleList;
        print('_bottlepost.length: ${_bottlepost.length}');
        isBottleLoding = false;
      });
    }); // BottleControllerからデータを取得
  }

  @override
  Widget build(BuildContext context) {
    if (isMenuLoding && isBottleLoding) {
      return Center(
          // プログレスインディケーターの表示
          child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ));
    } else {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConst.background,
          appBar: AppBarComponentWidget(
            isInfoIconEnabled: true,
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              //調味料表示
              _Seasoning(),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 列の数
                    ),
                    itemCount: _recipepost.length,
                    itemBuilder: (context, index) {
                      int reversedIndex = _recipepost.length - 1 - index;
                      return CardComponent(
                        recipe: _recipepost[reversedIndex],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorConst.mainColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Alert()));
            },
            child: Icon(Icons.add),
          ),
        ),
      );
    }
  }

//調味料ウィジェット
  Widget _Seasoning() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/bac.svg',
            fit: BoxFit.fill,
          ),
          Padding(
            // TODO ： 綺麗に書く
            padding: EdgeInsets.only(right: 12, left: 12, top: _bottlepost.length == 0 ? MediaQuery.of(context).size.height * 0.2 * 0.05 : MediaQuery.of(context).size.height * 0.2 * 0.1),
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ReorderableListView(
                    scrollDirection: Axis.horizontal,
                    onReorder: (int oldIndex, int newIndex) {
                      print(oldIndex);
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final BottleModel bottle = _bottlepost.removeAt(oldIndex);
                        _bottlepost.insert(newIndex, bottle);
                      });
                    },
                    children: _bottlepost.map((BottleModel bottle) {
                      return Container(
                        key: ValueKey(bottle.bottleId), // Set a unique key for each item
                        child: Row(
                          children: [
                            BottleComponent(bottle: bottle),
                            SizedBox(width: 15),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// test data
  void _insert() async {
    Uint8List imageBytes = (await rootBundle.load('assets/images/recipe/sample/curry.png')).buffer.asUint8List();

    Map<String, dynamic> row = {DatabaseHelper.menuName: 'カレー', DatabaseHelper.menuImage: imageBytes};
    final id = await dbHelper.insert(row);
    print('登録しました。id: $id');
  }

  void _inserta() async {
    Map<String, dynamic> row = {DatabaseHelper.menuName: 'ハンバーグ', DatabaseHelper.menuImage: 'recipe2.jpg'};
    final id = await dbHelper.inserta(row);
    print('登録しました。id: $id');
  }

  void _insertb() async {
    Map<String, dynamic> row = {DatabaseHelper.ASeasoningName: '醤油', DatabaseHelper.AteaSecond: 1.2};
    final id = await dbHelper.insertb(row);
    print('登録しました。id: $id');
  }

  void _insertc() async {
    Map<String, dynamic> row = {DatabaseHelper.seasoningName: '醤油', DatabaseHelper.teaSecond: 1.2};
    final id = await dbHelper.insertc(row);
    print('登録しました。id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('全てのデータを照会しました。');
    setState(() {
      _queryResult = allRows;
    });
  }

  void _delete() async {
    final id = await dbHelper.delete();
    _query();
    print('削除しました。id: $id');
  }
}
