import 'package:flutter/material.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../constant/String_constant.dart';
import 'package:sazikagen/model/bottle_model.dart';
import '../db/database_helper.dart';
import '../model/recipe_model.dart';
import '../controller/recipe_controller.dart';
import '../controller/bottle_controller.dart';
import '../component/card.dart';
import '../component/bottle.dart';
import '../model/rectangle_model.dart';

import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> _recipepost = [];
  List<BottleModel> _bottlepost = [];
  List<BottleModel> _bottleadmin = [];

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
    // _insert();
    // _inserta();
    _insertb();
    // _insertc();
    _query();

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
        isBottleLoding = false;
      });
    }); // BottleControllerからデータを取得
    await BottleController.bottleList().then((bottleList) {
      setState(() {
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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(96.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      'assets/images/appbar.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 15.0,
                    right: 16.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: ColorConst.black,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/info');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              //調味料表示
              _Seasoning(seasoningItem()),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 列の数
                      ),
                      itemCount: _recipepost.length,
                      itemBuilder: (context, index) {
                        int reversedIndex = _recipepost.length - 1 - index;
                        return CardComponent(
                          recipe: _recipepost[reversedIndex],
                        );
                      }))
            ],
          ),
        ),
      );
    }
  }

//調味料ウィジェット

  Widget _Seasoning(seasoningItem recipeItem) {
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
            padding: EdgeInsets.only(
                right: 12,
                left: 12,
                top: _queryResult.length == 0
                    ? MediaQuery.of(context).size.height * 0.2 * 0.45
                    : MediaQuery.of(context).size.height * 0.2 * 0.1),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                    ),
                    onPressed: () {
                      _Alertdrpodown(recipeItem);
                    }),
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
                        final BottleModel bottle =
                            _bottlepost.removeAt(oldIndex);
                        _bottlepost.insert(newIndex, bottle);
                      });
                    },
                    children: _bottlepost.map((BottleModel bottle) {
                      return Container(
                        key: ValueKey(
                            bottle.bottleId), // Set a unique key for each item
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

  List<seasoningItem> _rectangleList = [];
  List<BottleModel> _bottleController = [];
  int index = 0;

  void State() {
    super.initState();
    _initializeState();
  }

  Future<void> _State() async {
    // 登録済みの調味料を取得
    _bottleController = BottleController.bottleLists;
  }

  _Alertdrpodown(seasoningItem recipeItem) {
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
                  builder: (BuildContext context, StateSetter setState) =>
                      Center(
                          child: DropdownButton<BottleModel>(
                        underline: Container(),
                        value: recipeItem.selectedBottle,
                        onChanged: (newValue) {
                          setState(() {
                            recipeItem.selectedBottle = newValue;
                          });
                        },
                        items: _bottleadmin.map((bottle) {
                          return DropdownMenuItem<BottleModel>(
                            value: bottle,
                            child: Text(bottle.bottleTitle),
                          );
                        }).toList(),
                      )))),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  // TODO : プログラム書く
                });
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
    Map<String, dynamic> row = {
      DatabaseHelper.menuName: 'オムライス',
      DatabaseHelper.menuImage: 'recipe1.jpg'
    };
    final id = await dbHelper.insert(row);
    print('登録しました。id: $id');
  }

  void _inserta() async {
    Map<String, dynamic> row = {
      DatabaseHelper.menuName: 'ハンバーグ',
      DatabaseHelper.menuImage: 'recipe2.jpg'
    };
    final id = await dbHelper.inserta(row);
    print('登録しました。id: $id');
  }

//
  void _insertb() async {
    Map<String, dynamic> row = {
      DatabaseHelper.ASeasoningName: 'みりん',
      DatabaseHelper.AteaSecond: 1.2
    };

    final id = await dbHelper.insertb(row);
    print('登録しました。id: $id');
  }

  void _insertc() async {
    Map<String, dynamic> row = {
      DatabaseHelper.seasoningName: '醤油',
      DatabaseHelper.teaSecond: 1.2
    };
    final id = await dbHelper.insertc(row);
    print('登録しました。id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('全てのデータを照会しました。');
    print(allRows);
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
