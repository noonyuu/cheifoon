import 'package:flutter/material.dart';
import 'package:sazikagen/page/home_page.dart';
import '../component/loading.dart';
import '../constant/color_constant.dart';
import '../constant/layout.dart';
import '../controller/admin_bottle_controller.dart';
import '../controller/recipe_controller.dart';
import '../controller/user_bottle_controller.dart';
import '../db/database_helper.dart';
import '../model/admin_bottle/admin_bottle_model.dart';
import '../model/recipe/recipe_model.dart';
import '../model/user_bottle/user_bottle_model.dart';

class BranchPoint extends StatefulWidget {
  const BranchPoint({super.key});

  @override
  State<StatefulWidget> createState() => _BranchPoint();
}

class _BranchPoint extends State<BranchPoint> {
  List<Recipe> _recipePost = []; // レシピデータ
  List<UserBottle> _bottlePost = []; // 調味料データ
  List<AdminBottle> _bottleAdmin = []; // 用意されてる調味料データ
  final dbHelper = DatabaseHelper.instance; // DBヘルパー

  // Map<dynamic, bool> fetchCheck = {
  //   'menu': true,
  //   'bottle': true,
  //   'adminBottle': false,
  // };

  // late SizeConfig sizeConfig;

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeState();
  // }

  // Future<void> _initializeState() async {
  //   setState(() {
  //     // 各データを初期化
  //     _recipePost.clear();
  //     _bottlePost.clear();
  //     _bottleAdmin.clear();
  //     // 全フラグを初期化
  //     Map.fromEntries(fetchCheck.entries.map((entry) => MapEntry(entry.key, true)));
  //   });

  bool isMenuLading = true; // レシピデータ取得中のフラグ
  bool isBottleLading = true; // 調味料データ取得中のフラグ

  late SizeConfig sizeConfig;

  Map<dynamic, bool> fetchCheck = {
    'menu': false,
    'bottle': false,
    'adminBottle': false,
  };

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
        if (menuList.isNotEmpty) {
          fetchCheck['menu'] = true;
        }
      });
    });
    await BottleController.bottleList().then((bottleList) {
      print('b');
      setState(() {
        _bottlePost = bottleList;
        fetchCheck['bottle'] = true;
      });
    });
    await BottleAdminController.bottleList().then((bottleList) {
      setState(() {
        _bottleAdmin = bottleList;
        fetchCheck['adminBottle'] = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (fetchCheck.values.every((value) => value == true)) {
    if (fetchCheck.values.every((value) => value == true)) {
      sizeConfig = SizeConfig();
      sizeConfig.init(context);
      if (sizeConfig.orientation == Orientation.portrait && sizeConfig.screenWidth < mobileWidth) {
        return HomePage(
          recipePost: _recipePost,
          bottlePost: _bottlePost,
          bottleAdmin: _bottleAdmin,
          size: PhoneSize.verticalMobile,
        );
      } else if (sizeConfig.orientation == Orientation.landscape && sizeConfig.screenHeight < mobileHeight) {
        return HomePage(
          recipePost: _recipePost,
          bottlePost: _bottlePost,
          bottleAdmin: _bottleAdmin,
          size: PhoneSize.horizonMobile,
        );
      } else if (sizeConfig.orientation == Orientation.portrait && sizeConfig.screenWidth <= tabletWidth) {
        print("縦");
        return HomePage(
          recipePost: _recipePost,
          bottlePost: _bottlePost,
          bottleAdmin: _bottleAdmin,
          size: PhoneSize.verticalTablet,
        );
      } else {
        print("横");
        return HomePage(
          recipePost: _recipePost,
          bottlePost: _bottlePost,
          bottleAdmin: _bottleAdmin,
          size: PhoneSize.horizonTablet,
        );
      }
    } else {
      return Loading(
        size: PhoneSize.horizonTablet,
      );
    }
  }
}
