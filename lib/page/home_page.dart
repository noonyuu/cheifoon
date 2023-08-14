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

import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> _recipepost = [];
  List<BottleModel> _bottlepost = [];
  final dbHelper = DatabaseHelper.instance;
  bool isMenuLoding = true;
  bool isBottleLoding = true;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    // dbHelper.queryAllRows();
    // _insert();
    // _query();
    await RecipeController.menuList().then((menuList) {
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
              _Seasoning(),
              const SizedBox(
                height: 30,
              ),
              Expanded(
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
                      }))
            ],
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
            padding: EdgeInsets.only(right: 12, left: 12, top: 12),
            child: Row(
              children: [
                // Icon(
                //   Icons.arrow_left_outlined,
                // ),
                Icon(
                  Icons.add_circle_outline,
                ),
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
                  ),
                ),
                // Icon(
                //   Icons.arrow_right_outlined,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void _insert() async {
  //   Map<String, dynamic> row = {DatabaseHelper.menuName: 'オムライス', DatabaseHelper.menuImage: 'recipe1.jpg'};
  //   final id = await dbHelper.insert(row);
  //   print('登録しました。id: $id');
  // }
  void _insert() async {
    Map<String, dynamic> row = {DatabaseHelper.seasoningName: '醤油', DatabaseHelper.teaSecond: 1.2};
    final id = await dbHelper.insert(row);
    print('登録しました。id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('全てのデータを照会しました。');
    setState(() {
      // _recipepost = allRows;
    });
  }
}
