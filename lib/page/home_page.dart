import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../component/app_bar.dart';
import '../component/button.dart';
import '../component/card.dart';
import '../component/insert_seasoning_alert.dart';
import '../component/rack.dart';
import '../component/text_field.dart';
import '../constant/color_constant.dart';
import '../constant/layout.dart';
import '../controller/admin_bottle_controller.dart';
import '../controller/recipe_controller.dart';
import '../controller/user_bottle_controller.dart';
import '../db/database_helper.dart';
import '../model/admin_bottle/admin_bottle_model.dart';
import '../model/recipe/recipe_model.dart';
import '../model/rectangle_model.dart';
import '../model/user_bottle/user_bottle_model.dart';
import '../responsive/app_bar_size.dart';
import '../responsive/show_seasoning_size.dart';
import 'add_alert.dart';

class HomePage extends StatefulWidget {
  final List<Recipe> recipePost;
  final List<UserBottle> bottlePost;
  final List<AdminBottle> bottleAdmin;
  final PhoneSize size;
  const HomePage({
    required this.recipePost,
    required this.bottlePost,
    required this.bottleAdmin,
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _recipePost = []; // レシピデータ
  List<UserBottle> _bottlePost = []; // 調味料データ
  List<AdminBottle> _bottleAdmin = []; // 用意されてる調味料データ
  // final dbHelper = DatabaseHelper.instance; // DBヘルパー

  Map<dynamic, bool> fetchCheck = {
    'menu': false,
    'bottle': false,
    'adminBottle': false,
  };

  String _textFieldValue = ''; // レシピ検索

  late PhoneSize _size;
  late SizeConfig sizeConfig;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      _recipePost = widget.recipePost;
      _bottlePost = widget.bottlePost;
      _bottleAdmin = widget.bottleAdmin;
      _size = widget.size;

      setState(() {
        Map.fromEntries(fetchCheck.entries.map((entry) => MapEntry(entry.key, true)));
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Future<void> _initializeState() async {
    setState(() {
      // 各データを初期化
      _recipePost.clear();
      _bottlePost.clear();
      _bottleAdmin.clear();
      // 全フラグを初期化
      Map.fromEntries(fetchCheck.entries.map((entry) => MapEntry(entry.key, false)));
    });
    // レシピデータを取得
    await RecipeController.menuList().then((menuList) {
      setState(() {
        _recipePost = menuList;
        fetchCheck['menu'] = true;
      });
    }); // ユーザーがセットした調味料を取得
    await BottleController.bottleList().then((bottleList) {
      setState(() {
        _bottlePost = bottleList;
        fetchCheck['bottle'] = true;
      });
    }); // 用意されてる調味料を取得
    await BottleAdminController.bottleList().then((bottleList) {
      setState(() {
        fetchCheck['adminBottle'] = true;
      });
    });
  }

  // 調味料削除時に再描画
  void deleteBottle() async {
    setState(() {
      _initializeState();
    });
  }

  void insertBottle() async {
    setState(() {
      _initializeState().then((_) {
        Navigator.pop(context, true);
        if (kDebugMode) print('$_bottleAdmin.追加しました');
      });
    });
  }

  // テキストフィールドの変更イベントをハンドリング
  void _onTextFieldChanged(String value) {
    setState(() {
      _textFieldValue = value;
    });
  }

  // 送信ボタンが押された時の処理
  void _onSubmitButtonPressed() {
    // ここで _textFieldValue を使ってデータを送信する処理を行う
    print('Sending data: $_textFieldValue');
  }

  @override
  Widget build(BuildContext context) {
    // print('確認データ${_recipePost}');
    sizeConfig = SizeConfig();
    sizeConfig.init(context);

    if (fetchCheck.values.every((value) => value == true)) {
      for(int i = 0; i < fetchCheck.length; i++) {
        print(fetchCheck.values.toList()[i]);
      }
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
          resizeToAvoidBottomInset: false, // キーボードを被せる
          backgroundColor: ColorConst.background,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(sizeConfig.screenHeight * appBar(_size)),
            child: AppBarComponentWidget(
              title: 'Cheifoon',
              isInfoIconEnabled: true,
              context: context,
            ),
          ),
          // リフレッシュ
          body: RefreshIndicator(
            onRefresh: () async {
              // 新しいデータを取得する処理
              _initializeState();
            },
            child: Column(
              children: [
                SizedBox(
                  height: sizeConfig.screenHeight * 0.4,
                  child: Stack(
                    children: [
                      // 調味料表示
                      Seasoning(
                          notifyParent: deleteBottle,
                          bottlePost: _bottlePost,
                          height: showSeasoning(_size).height,
                          width: showSeasoning(_size).width,
                          bottomPadding: showSeasoning(_size).bottomPadding,
                          bottleHeight: showSeasoning(_size).bottleHeight),

                      Positioned(
                        top: sizeConfig.screenHeight * 0.19,
                        left: sizeConfig.screenWidth * 0.1,
                        child: Row(
                          children: [
                            SizedBox(
                              // height: sizeConfig.screenHeight * 0.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: sizeConfig.screenWidth * 0.03),
                                    child: CustomTextField(
                                      labelText: 'レシピ',
                                      hintText: 'レシピを絞り込む',
                                      obscureText: false,
                                      height: 0.1,
                                      width: 0.3,
                                      labelSize: 20,
                                      hintSize: 20,
                                      textField: 30,
                                      onChanged: _onTextFieldChanged,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: sizeConfig.screenWidth * 0.1),
                                    child: const CustomButton(
                                      buttonTitle: '検索',
                                      height: 0.08,
                                      width: 0.15,
                                      textSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 追加ボタン
                            SizedBox(
                                width: sizeConfig.screenWidth * 0.15,
                                height: sizeConfig.screenWidth * 0.15,
                                child: GestureDetector(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) => InsertSeasoningAlert(
                                      itemAdmin: ItemAdmin(),
                                      bottleAdmin: _bottleAdmin,
                                      bottlePost: _bottlePost,
                                      insertBottle: insertBottle,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/memo.png',
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ),
                                      Center(child: Text("調味料追加", style: TextStyle(fontSize: sizeConfig.screenWidth * 0.02))),
                                    ],
                                  ),
                                )),
                            SizedBox(width: sizeConfig.screenWidth * 0.01),
                            SizedBox(
                                width: sizeConfig.screenWidth * 0.15,
                                height: sizeConfig.screenWidth * 0.15,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Alert()));
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/memo.png',
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ),
                                      Center(child: Text("レシピ追加", style: TextStyle(fontSize: sizeConfig.screenWidth * 0.02))),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: sizeConfig.screenHeight * 0.07, left: sizeConfig.screenWidth * 0.02),
                      child: SizedBox(
                        height: sizeConfig.screenHeight * 0.3,
                        child: Container(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _recipePost.length,
                            itemBuilder: (context, index) {
                              int reversedIndex = _recipePost.length - 1 - index;
                              return Padding(
                                padding: EdgeInsets.fromLTRB(sizeConfig.screenWidth * 0.01, 0, sizeConfig.screenWidth * 0.02, 0),
                                child: SizedBox(
                                  width: sizeConfig.screenHeight * 0.3,
                                  height: sizeConfig.screenHeight * 0.3,
                                  child: CardComponent(
                                    recipe: _recipePost[reversedIndex],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
