import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'addalert.dart';
import '../model/rectangle_model.dart';
import '../model/recipe_model.dart';
import '../model/bottle_model.dart';
import '../constant/color_constant.dart';
import '../db/database_helper.dart';
import '../controller/recipe_controller.dart';
import '../controller/bottle_controller.dart';
import '../component/card.dart';
import '../component/bottle.dart';
import '../component/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> _menuPost = []; // レシピデータ
  List<BottleModel> _bottlePost = []; // 調味料データ
  List<BottleAdminModel> _bottleAdmin = []; // 用意されてる調味料データ
  List<Map<String, dynamic>> _queryResult = [];
  final dbHelper = DatabaseHelper.instance;

  bool isMenuLading = true; // レシピデータ取得中のフラグ
  bool isBottleLading = true; // 調味料データ取得中のフラグ

  bool isInsertSeasoning = false; // 調味料を追加したかどうかのフラグ

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    setState(() {
      // 各データを初期化
      _menuPost.clear();
      _bottlePost.clear();
      _bottleAdmin.clear();
      // 各フラグを初期化
      isMenuLading = true;
      isBottleLading = true;
    });
    await RecipeController.menuList().then((menuList) {
      setState(() {
        _menuPost = menuList;
        isMenuLading = false;
      });
    }); // RecipeControllerからデータを取得
    await BottleController.bottleList().then((bottleList) {
      setState(() {
        _bottlePost = bottleList;
        isBottleLading = false;
      });
    }); // BottleControllerからデータを取得
    await BottleAdminController.bottleList().then((bottleList) {
      setState(() {
        _bottleAdmin = bottleList;
        // isBottleLading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isMenuLading && isBottleLading) {
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
                        itemCount: _menuPost.length,
                        itemBuilder: (context, index) {
                          int reversedIndex = _menuPost.length - 1 - index;
                          return CardComponent(
                            recipe: _menuPost[reversedIndex],
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Alert()));
                    },
                    child: Icon(Icons.add),
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
                    children: List.generate(_bottlePost.length, (index) {
                      return Row(
                        children: [
                          BottleComponent(bottle: _bottlePost[index]),
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
                  items: _bottleAdmin.map((bottle) {
                    return DropdownMenuItem<BottleAdminModel>(
                      value: bottle,
                      child: Text(bottle.bottleTitle),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (itemAdmin.selectedBottle != null) {
                  BottleAdminModel selectedBottle = itemAdmin.selectedBottle!;

                  BottleModel newBottle = BottleModel(
                    bottleId: selectedBottle.bottleId,
                    bottleTitle: selectedBottle.bottleTitle,
                    teaSecond: selectedBottle.teaSecond,
                  );

                  setState(() {
                    int id = itemAdmin.selectedBottle!.bottleId;
                    String name = itemAdmin.selectedBottle!.bottleTitle;
                    double tea = itemAdmin.selectedBottle!.teaSecond;
                    // 調味料を追加
                    _insertSeasoning(id, name, tea);
                    _bottlePost.add(newBottle);
                    _initializeState().then((_) {
                      isInsertSeasoning = true;
                    });
                  });
                  if (isInsertSeasoning) {
                    // ダイアログを閉じる
                    Navigator.pop(context, true);
                  }
                  print('追加しました');
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
    Map<String, dynamic> row = {DatabaseHelper.menuName: 'カレー', DatabaseHelper.menuImage: imageBytes};
    final id = await dbHelper.insert(row);
    print('登録しました。id: $id');
  }

  void _insertb() async {
    Map<String, dynamic> row = {DatabaseHelper.ASeasoningName: 'ウスターソース', DatabaseHelper.AteaSecond: 1.2};
    final id = await dbHelper.insertb(row);
    print('登録しました。id: $id');
  }

// userがセットした調味料を追加
  void _insertSeasoning(int seasoningId, String title, double tea) async {
    Map<String, dynamic> row = {DatabaseHelper.seasoningId: seasoningId, DatabaseHelper.seasoningName: title, DatabaseHelper.teaSecond: tea};
    await dbHelper.insertSeasoning(row);
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
