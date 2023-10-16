import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sazikagen/component/appbar.dart';
import 'package:sazikagen/constant/color_constant.dart';
import 'package:sazikagen/logic/connection.dart';
import 'package:sazikagen/model/recipe_model.dart';

import '../db/database_helper.dart';
import '../db/menu_show.dart';
import '../logic/connection.dart';
import 'home_page.dart';

class Send extends StatefulWidget {
  const Send({Key? key, required this.recipe}) : super(key: key);

  @override
  State<Send> createState() => _SendState();

  final RecipeModel recipe;
}

class _SendState extends State<Send> {
  final dbHelper = DatabaseHelper.instance;
  // List<String> seasoningList = ['醤油', 'ウスターソース']; // 調味料のリスト
  List<dynamic> queryRecipe = [];
  List<Map<String, dynamic>> querySeasoning = [];

  late RecipeModel _recipe; // レシピをここに保存

  bool isLodging = false;

  List<String> seasoningName = [];
  List<String> seasoningId = [];
  List<String> tableSpoon = [];
  List<String> teaSpoon = [];

  @override
  void initState() {
    _recipe = widget.recipe;
    super.initState();
    // _query();
    _initializeState();
  }

  Future<void> _initializeState() async {
    recipeTable().then((_) {
      print('$queryRecipeを照会しました。');
      isLodging = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLodging) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: AppBarComponentWidget(
            isInfoIconEnabled: false,
          ),
          // 全体画面
          backgroundColor: ColorConst.background,
          body: Column(
            children: [
              const SizedBox(
                // 検索バーの上に隙間入れるためのやつ
                height: 30,
              ),
              Stack(
                alignment: Alignment.center, // 検索バー背景を真ん中に持ってくる
                children: [
                  Container(
                    // 検索バーの背景の四角形
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: ShapeDecoration(
                      color: ColorConst.recipename,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(width: 0.50),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _recipe.title,
                      // queryRecipe.length.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                // 検索バーと調味料の間に隙間入れるために設置
                height: 20,
              ),
              Column(
                children: [
                  const SizedBox(height: 30), // 上部のスペース
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6, // 画面の一部に制約を設定
                    child: ListView(
                      children: queryRecipe.map((dataKey) {
                        // final data = queryRecipe[dataKey];
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height * 0.15,
                                decoration: ShapeDecoration(
                                  color: ColorConst.recipename,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(width: 0.50),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  const SizedBox(width: 230),
                                  FutureBuilder<List<Map<String, dynamic>>>(
                                    future: dbHelper.querySeasoningId(dataKey['seasoning_id'].toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else {
                                        seasoningName.add(snapshot.data![0]['seasoning_name']);
                                        seasoningId.add(dataKey['seasoning_id'].toString());
                                        tableSpoon.add(dataKey['table_spoon'].toString());
                                        teaSpoon.add(dataKey['tea_spoon'].toString());
                                        return Text(snapshot.data![0]['seasoning_name']);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: [
                                  Text('大さじ    ${dataKey['table_spoon']}'),
                                  const SizedBox(height: 25),
                                  Text('小さじ    ${dataKey['tea_spoon']}'),
                                  const SizedBox(width: 260),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildBackButton(),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.53,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildSendButton(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  // void _query() async {
  //   final allRows = await dbHelper.queryRecipe();
  //   print('全てのデータを照会しました。');
  //   setState(() {
  //     queryRecipe = allRows;
  //   });
  // }

  recipeTable() async {
    print('recipeID:${_recipe.recipeId}');
    List<dynamic> tmpMenu = await getMenu(_recipe.recipeId);
    setState(() {
      queryRecipe = tmpMenu;
    });
  }

  seasoningTable(String id) async {
    final seasoningInfo = await dbHelper.querySeasoningId(id);
    if (seasoningInfo.isNotEmpty) {
      setState(() {
        querySeasoning = seasoningInfo.first['seasoning_name'];
      });
    }
  }

  // 戻るボタン
  Widget _buildBackButton() {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
          // 更新かけるとおかしくなる
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.04,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/spoon_button.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  '戻る',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }

// 決定ボタン
  Widget _buildSendButton() {
    return TextButton(
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => HomePage()));
          connection.fetchDataFromRaspberryPi(_recipe.title, seasoningId, seasoningName, tableSpoon, teaSpoon);
          showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return SendAlertDialog();
              });
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.04,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/spoon_button.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '送信',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }
}

class SendAlertDialog extends StatelessWidget {
  const SendAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorConst.background,
      title: Center(child: Text('送信しました！')),
      content: Text(
        '機械の画面指示に\n従って進めてください!',
        textAlign: TextAlign.center, // テキストを中央揃えにする
      ),
      shape: RoundedRectangleBorder(
        // 枠線を追加
        borderRadius: BorderRadius.circular(10.0), // 角丸の半径を設定
        side: BorderSide(color: ColorConst.mainColor, width: 5.0), // 枠線の設定
      ),
      actions: <Widget>[
        GestureDetector(
          child: Text('はい'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.pop(context);
            // 更新かけるをおかしくなる
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        )
      ],
    );
  }
}
