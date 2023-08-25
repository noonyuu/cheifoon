import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../component/appbar.dart';
import '../model/rectangle_model.dart';
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
  List<BottleAdminModel> _bottleadmin = [];
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
    await RecipeController.menuList().then((menuList) {
      setState(() {
        _recipepost.clear();
        isMenuLoding = true;
        setState(() {});
        _recipepost = menuList;
        isMenuLoding = false;
      });
    }); // RecipeControllerからデータを取得
    await BottleController.bottleList().then((bottleList) {
      setState(() {
        _bottlepost.clear();
        isBottleLoding = true;
        setState(() {});
        _bottlepost = bottleList;
        isBottleLoding = false;
      });
    }); // BottleControllerからデータを取得
    await BottleAdminController.bottleList().then((bottleList) {
      setState(() {
        _bottleadmin.clear();
        _bottleadmin = bottleList;
        // isBottleLoding = false;
      });
    });
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
            body: RefreshIndicator(
              onRefresh: () async {
                // 新しいデータを取得する処理
                initState();
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  //調味料表示
                  _Seasoning(ItemAdmin(), seasoningItem()),
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
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  backgroundColor: ColorConst.mainColor,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Alert()));
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 16), // ボタン間にスペースを空けるための SizedBox
                FloatingActionButton(
                  heroTag: "btn2",
                  backgroundColor: ColorConst.mainColor,
                  onPressed: () {
                    _insertb(); //a_醤油
                    // _insertc(); //醤油
                  },
                  child: Icon(Icons.add),
                ),
              ],
            )),
      );
    }
  }

//調味料ウィジェット
  Widget _Seasoning(ItemAdmin itemAdmin, seasoningItem recipeItem) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/images/bac.svg',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            // TODO ： 修正必須
            padding: EdgeInsets.only(right: 12, left: 12, top: _bottlepost.isEmpty ? MediaQuery.of(context).size.height * 0.2 * 0.4 : MediaQuery.of(context).size.height * 0.2 * 0.1),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                    ),
                    onPressed: () {
                      _Alertdrpodown(itemAdmin);
                    }),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_bottlepost.length, (index) {
                      return Row(
                        children: [
                          BottleComponent(bottle: _bottlepost[index]),
                          Container(
                            width: 15,
                          )
                        ],
                      );
                    }),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  int index = 0;

  void State() {
    super.initState();
    _initializeState();
  }

  // Future<void> _State() async {
  //   // 登録済みの調味料を取得
  //   List<BottleModel> _bottleController = [];

  //   _bottleController = BottleController.bottleLists;
  // }

  List<Map<String, dynamic>> queryList = [];

  _Alertdrpodown(ItemAdmin itemAdmin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorConst.background,
          title: const Column(
            children: [
              Center(
                  child: Text(
                '調味料を選択',
              )),
              SizedBox(
                height: 30,
              )
            ],
          ),
          content: Container(
              height: 50,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) => Center(
                          child: DropdownButton<BottleAdminModel>(
                        underline: Container(), //下線なくす
                        value: itemAdmin.selectedBottle,
                        onChanged: (newValue) {
                          setState(() {
                            itemAdmin.selectedBottle = newValue;
                          });
                        },
                        items: _bottleadmin.map((bottle) {
                          return DropdownMenuItem<BottleAdminModel>(
                            value: bottle,
                            child: Text(bottle.bottleTitle),
                          );
                        }).toList(),
                      )))),
          actions: [
            IconButton(
              onPressed: () {
                if (itemAdmin.selectedBottle != null) {
                  BottleAdminModel selectedBottle = itemAdmin.selectedBottle!;

                  BottleModel newBottle = BottleModel(
                    bottleId: selectedBottle.bottleId,
                    bottleTitle: selectedBottle.bottleTitle,
                  );

                  setState(() {
                    int id = itemAdmin.selectedBottle!.bottleId;
                    String name = itemAdmin.selectedBottle!.bottleTitle;
                    double tea = 1.2;
                    // TODO:ゴリ押しさん
                    // double tea = itemAdmin.selectedBottle!.teaSecond;

                    _insertc(id,name,tea);
                    _bottlepost.add(newBottle);
                    print(itemAdmin.selectedBottle!.bottleTitle);
                  });
                  print('追加しました');

                  // ダイアログを閉じる
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.add_circle,
                size: 20,
                color: Colors.black,
              ),
            )
          ],
        );
      },
    ).then((value) => setState(() {}));
  }

// test data
  void _insert() async {
    Uint8List imageBytes = (await rootBundle.load('assets/images/recipe/sample/curry.png')).buffer.asUint8List();
    print(Uint8List);
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
    Map<String, dynamic> row = {DatabaseHelper.ASeasoningName: 'ウスターソース', DatabaseHelper.AteaSecond: 1.2};
    final id = await dbHelper.insertb(row);
    print('登録しました。id: $id');
  }

  void _insertc(int seasoningId, String title , double tea) async {
    Map<String, dynamic> row = {DatabaseHelper.seasoningId: seasoningId, DatabaseHelper.seasoningName: title, DatabaseHelper.teaSecond: tea};
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
