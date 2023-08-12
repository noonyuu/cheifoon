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

  @override
  void initState() {
    super.initState();
    _insert();
    _query();
    _recipepost = RecipeController().recipe;
    _bottlepost = BottleController().bottle; // RecipeControllerからデータを取得
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConst.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(96.0),
          child: AppBar(
            backgroundColor: Colors.transparent, //背景を透明にする
            elevation: 0, //appberの影
            flexibleSpace: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
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
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/appBar.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
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

//調味料ウィジェット
  Widget _Seasoning() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bac.png'), // Background image path
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
        child: Row(
          children: [
            Icon(
              Icons.arrow_left_outlined,
            ),
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
                  children: [
                    // Icon(
                    //   Icons.arrow_left_outlined,
                    // ),
                    // Icon(
                    //   Icons.add_circle_outline,
                    // ),
                    Row(
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
                  ],
                ),
              ),
            ),
            Icon(
              Icons.arrow_right_outlined,
            ),
          ],
        ),
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {DatabaseHelper.menuName: 'オムライス', DatabaseHelper.menuImage: '~.png'};
    final id = await dbHelper.insert(row);
    print('登録しました。id: $id');
  }

    void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('全てのデータを照会しました。');
    allRows.forEach(print);
  }
}
