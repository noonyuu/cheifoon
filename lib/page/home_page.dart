import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../component/appbar.dart';
import '../component/bottle.dart';
import '../component/card.dart';
import '../constant/color_constant.dart';
import '../controller/admin_bottle_controller.dart';
import '../controller/recipe_controller.dart';
import '../controller/user_bottle_controller.dart';
import '../db/database_helper.dart';
import '../model/admin_botle/admin_bottle_model.dart';
import '../model/recipe/recipe_model.dart';
import '../model/rectangle_model.dart';
import '../model/user_bottle/user_bottle_model.dart';
import 'addalert.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _recipePost = [];            // レシピデータ
  List<UserBottle> _bottlePost = [];        // 調味料データ
  List<AdminBottle> _bottleAdmin = [];      // 用意されてる調味料データ
  final dbHelper = DatabaseHelper.instance; // DBヘルパー

  bool isMenuLading = true;                 // レシピデータ取得中のフラグ
  bool isBottleLading = true;               // 調味料データ取得中のフラグ

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    setState(() {
      // 各データを初期化
      _recipePost.clear();
      _bottlePost.clear();
      _bottleAdmin.clear();
      // 各フラグを初期化
      isMenuLading = true;
      isBottleLading = true;
    });
    // レシピデータを取得
    await RecipeController.menuList().then((menuList) {
      setState(() {
        _recipePost = menuList;
        isMenuLading = false;
      });
    }); // ユーザーがセットした調味料を取得
    await BottleController.bottleList().then((bottleList) {
      setState(() {
        _bottlePost = bottleList;
        isBottleLading = false;
      });
    }); // 用意されてる調味料を取得
    await BottleAdminController.bottleList().then((bottleList) {
      setState(() {
        _bottleAdmin = bottleList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isMenuLading && isBottleLading) {
      return const Center(
        // プログレスインディケーターの表示
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConst.background,
            appBar: const AppBarComponentWidget(
              isInfoIconEnabled: true,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                // 新しいデータを取得する処理
                _initializeState();
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
                        itemCount: _recipePost.length,
                        itemBuilder: (context, index) {
                          int reversedIndex = _recipePost.length - 1 - index;
                          return CardComponent(
                            recipe: _recipePost[reversedIndex],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: "btn1",
                    backgroundColor: ColorConst.mainColor,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Alert()));
                    },
                    child: const Icon(Icons.add),
                  ), // ボタン間にスペースを空けるための SizedBox
                ],
              ),
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
            padding: EdgeInsets.only(right: 12, left: 12, top: _bottlePost.isEmpty ? MediaQuery.of(context).size.height * 0.2 * 0.4 : MediaQuery.of(context).size.height * 0.2 * 0.1),
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                    ),
                    onPressed: () {
                      _alertDropdown(itemAdmin);
                    }),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_bottlePost.length, (index) {
                        return Row(
                          children: [
                            BottleComponent(
                              key: UniqueKey(), // ここで UniqueKey を使用して異なるキーを持つインスタンスを生成
                              bottle: _bottlePost[index],
                              onDeletePressed: () {
                                // 削除ボタンが押されたときに再描画をトリガー
                                setState(() {
                                  _initializeState();
                                });
                              },
                            ),
                            Container(
                              width: 15,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> queryList = [];

  _alertDropdown(ItemAdmin itemAdmin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorConst.background,
          title: const Column(
            children: [
              Text(
                '調味料を選択',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: SizedBox(
              height: 50,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) => Center(
                  child: DropdownButton<AdminBottle>(
                    underline: Container(), //下線なくす
                    value: itemAdmin.selectedBottle,
                    onChanged: (newValue) {
                      setState(() {
                        itemAdmin.selectedBottle = newValue;
                      });
                    },
                    items: _bottleAdmin.map((bottle) {
                      return DropdownMenuItem<AdminBottle>(
                        value: bottle,
                        child: Text(bottle.admin_seasoning_name),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: _bottleAdmin.isEmpty ? const Text('もう登録できる調味料はありません') : Container()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (itemAdmin.selectedBottle != null) {
                          AdminBottle selectedBottle = itemAdmin.selectedBottle!;

                          UserBottle newBottle = UserBottle(
                            seasoning_id: selectedBottle.admin_seasoning_id,
                            seasoning_name: selectedBottle.admin_seasoning_name,
                            tea_second: selectedBottle.admin_tea_second,
                          );

                          setState(() {
                            int id = itemAdmin.selectedBottle!.admin_seasoning_id;
                            String name = itemAdmin.selectedBottle!.admin_seasoning_name;
                            double tea = itemAdmin.selectedBottle!.admin_tea_second;
                            // 調味料を追加
                            _insertSeasoning(id, name, tea);
                            _bottlePost.add(newBottle);
                            _initializeState().then((_) {
                              Navigator.pop(context, true);
                              if (kDebugMode) print('$_bottleAdmin.追加しました');
                            });
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        );
      },
    ).then((value) => setState(() {}));
  }

// userがセットした調味料を追加
  void _insertSeasoning(int seasoningId, String title, double tea) async {
    Map<String, dynamic> row = {DatabaseHelper.seasoningId: seasoningId, DatabaseHelper.seasoningName: title, DatabaseHelper.teaSecond: tea};
    await dbHelper.insertSeasoning(row);
  }
}
