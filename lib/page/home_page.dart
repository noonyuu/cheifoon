import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

import '../component/app_bar.dart';
import '../component/card_recipe.dart';
import '../component/card_seasoning.dart';
import '../component/insert_seasoning_alert.dart';
import '../component/loading.dart';
import '../constant/color_constant.dart';
import '../constant/layout.dart';
import '../controller/admin_bottle_controller.dart';
import '../controller/recipe_controller.dart';
import '../controller/user_bottle_controller.dart';
import '../model/admin_bottle/admin_bottle_model.dart';
import '../model/insert_bottle_model.dart';
import '../model/recipe/recipe_model.dart';
import '../model/rectangle_model.dart';
import '../model/user_bottle/user_bottle_model.dart';
import '../Gacha_icons.dart';
import 'add_recipe.dart';
import 'gacha.dart';

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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Recipe> _recipePost = []; // レシピデータ
  List<UserBottle> _bottlePost = []; // 調味料データ
  List<AdminBottle> _bottleAdmin = []; // 用意されてる調味料データ

  InsertBottleModel insertBottleModel = InsertBottleModel();

  Map<dynamic, bool> fetchCheck = {
    'menu': false,
    'bottle': false,
    'adminBottle': false,
  };

  String _textFieldValue = ''; // レシピ検索

  late PhoneSize _size;
  late SizeConfig sizeConfig;

  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    loadData();

    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
  }

  void screenReset() {
    _size = widget.size;
  }

  @override
  void dispose() {
    super.dispose();

    _motionTabBarController!.dispose();
  }

  void loadData() async {
    try {
      insertBottleModel.setBottle(widget.bottlePost, false);
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
      Map.fromEntries(fetchCheck.entries.map((entry) => MapEntry(entry.key, true)));
    });
    // レシピデータを取得
    await RecipeController.menuList().then((menuList) {
      setState(() {
        _recipePost = menuList;
        fetchCheck['menu'] = false;
      });
    }); // ユーザーがセットした調味料を取得
    await BottleController.bottleList().then((bottleList) {
      setState(() {
        _bottlePost = bottleList;
        fetchCheck['bottle'] = false;
      });
    }); // 用意されてる調味料を取得
    await BottleAdminController.bottleList().then((bottleList) {
      setState(() {
        fetchCheck['adminBottle'] = false;
      });
    });
  }

  // 調味料削除時に再描画
  void deleteBottle() async {
    _bottlePost.clear();
    await BottleController.bottleList().then((bottleList) {
      insertBottleModel.setBottle(widget.bottlePost, false);
    }); // 用意
  }

  void insertBottle() async {
    setState(() {
      insertBottleModel.setBottle(insertBottleModel.bottle, fetchCheck['bottle']!);
      Navigator.pop(context, true);
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
    sizeConfig = SizeConfig();
    sizeConfig.init(context);

    if (fetchCheck.values.every((value) => value == true)) {
      return const Loading(
        size: PhoneSize.horizonTablet,
      );
    } else {
      return PopScope(
        canPop: false,
        child: SafeArea(
          child: DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              resizeToAvoidBottomInset: false, // キーボードを被せる
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(sizeConfig.screenHeight * appBar(_size)),
                child: AppBarComponentWidget(
                  title: 'Cheifoon',
                  isInfoIconEnabled: true,
                  context: context,
                  size: _size,
                ),
              ), // リフレッシュ
              bottomNavigationBar: MotionTabBar(
                controller: _motionTabBarController, // ADD THIS if you need to change your tab programmatically
                initialSelectedTab: "ホーム",
                labels: const ["Dashboard", "ホーム", "ガチャ"],
                icons: const [Icons.dashboard, Icons.home, Gacha.gacha],

                // optional badges, length must be same with labels
                // badges: [
                //   // Default Motion Badge Widget
                //   const MotionBadgeWidget(
                //     text: '99+',
                //     textColor: Colors.white, // optional, default to Colors.white
                //     color: Colors.red, // optional, default to Colors.red
                //     size: 18, // optional, default to 18
                //   ),

                //   // custom badge Widget
                //   Container(
                //     color: Colors.black,
                //     padding: const EdgeInsets.all(2),
                //     child: const Text(
                //       '48',
                //       style: TextStyle(
                //         fontSize: 14,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),

                //   // Default Motion Badge Widget with indicator only
                //   const MotionBadgeWidget(
                //     isIndicator: true,
                //     color: Colors.red, // optional, default to Colors.red
                //     size: 5, // optional, default to 5,
                //     show: true, // true / false
                //   ),
                // ],
                tabSize: 50,
                tabBarHeight: 55,
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                tabIconColor: ColorConst.black,
                tabIconSize: 30.0,
                tabIconSelectedSize: 35.0,
                tabSelectedColor: ColorConst.strongMainColors,
                tabIconSelectedColor: Colors.white,
                tabBarColor: ColorConst.mainColors,
                onTabItemSelected: (int value) {
                  setState(() {
                    // _tabController!.index = value;
                    _motionTabBarController!.index = value;
                  });
                },
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
                controller: _motionTabBarController,
                children: <Widget>[
                  MainPageContentComponent(title: "set", controller: _motionTabBarController!),
                  // MainPageContentComponent(title: "Home Page", controller: _motionTabBarController!),
                  OrientationBuilder(
                    builder: (context, orientation) {
                      // _bottlePost.clear();
                      // loadData();
                      screenReset();
                      return RefreshIndicator(
                        onRefresh: () async {
                          // 新しいデータを取得する処理
                          _initializeState();
                        },
                        child: Column(
                          children: [
                            Container(
                              color: ColorConst.mainColors,
                              child: const TabBar(
                                tabs: <Widget>[
                                  SizedBox(
                                    width: 100,
                                    child: Tab(text: 'レシピ'),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Tab(text: '調味料'),
                                  ),
                                ],
                                unselectedLabelColor: ColorConst.grey,
                                labelColor: ColorConst.black,
                                indicatorColor: ColorConst.strongMainColors,
                              ),
                            ),
                            Expanded(
                              child: TabBarView(children: <Widget>[
                                // レシピ
                                recipeTabContent(_recipePost),
                                seasoningTabContent(_bottlePost),
                              ]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // MainPageContentComponent(title: "Settings Page", controller: _motionTabBarController!),
                  SingleShotLottie(asset: 'assets/gacha.json'),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget recipeTabContent(List<Recipe> data) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: sizeConfig.screenHeight * 0.8,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: data.length,
            itemBuilder: (context, index) {
              int reversedIndex = data.length - 1 - index;
              return SizedBox(
                height: sizeConfig.screenHeight * 0.1,
                child: CardComponent(
                  recipe: data[reversedIndex],
                  size: _size,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Alert(_size)));
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddRecipe(size: _size))).then((reload) {
                  if (reload == true) {
                    _initializeState();
                  }
                });
              },
              backgroundColor: ColorConst.mainColors,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  Widget seasoningTabContent(List<UserBottle> data) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: sizeConfig.screenHeight * 0.8,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: data.length,
            itemBuilder: (context, index) {
              int reversedIndex = data.length - 1 - index;
              return SizedBox(
                height: sizeConfig.screenHeight * 0.1,
                child: SeasoningCardComponent(
                  bottle: data[reversedIndex],
                  size: _size,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => InsertSeasoningAlert(
                    itemAdmin: ItemAdmin(),
                    bottleAdmin: _bottleAdmin,
                    bottlePost: _bottlePost,
                    insertBottle: insertBottle,
                  ),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}

class MainPageContentComponent extends StatelessWidget {
  const MainPageContentComponent({
    required this.title,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final String title;
  final MotionTabBarController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          const Text('Go to "X" page programmatically'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => controller.index = 0,
            child: const Text('Dashboard Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 1,
            child: const Text('Home Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 3,
            child: const Text('Settings Page'),
          ),
        ],
      ),
    );
  }
}
