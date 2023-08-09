import 'package:flutter/material.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../constant/String_constant.dart';
import 'package:sazikagen/model/bottle_model.dart';
import '../model/recipe_model.dart';
import '../controller/recipe_controller.dart';
import '../controller/bottle_controller.dart';
import '../component/card.dart';
import '../component/bottle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> _recipepost = [];
  List<BottleModel> _bottlepost = [];

  @override
  void initState() {
    super.initState();
    _recipepost = RecipeController().recipe;
    _bottlepost = BottleController().bottle; // RecipeControllerからデータを取得
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent, //背景を透明にする
        elevation: 0, //appberの影
        title: Center(
          // タイトルを中央に配置
          child: Row(
            children: [
              Image.asset(
                StringConst.titlePath,
                height: 150,
                width: 330,
              ),
              Icon(
                Icons.info_outline_rounded,
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorConst.mainColor, // 枠線の色
              width: 5.0, // 枠線の幅
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
          //レシピ表示
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
    );
  }

//調味料ウィジェット
  Widget _Seasoning() {
    return Container(
        height: 140,
        width: 400,
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorConst.mainColor, // 枠線の色
            width: 5.0, // 枠線の幅
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Scrollbar(
            child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Icon(
                Icons.arrow_left_outlined,
              ),
              const Icon(
                Icons.add_circle_outline,
              ),
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
              const Icon(
                Icons.arrow_right_outlined,
              ),
            ],
          ),
        )));
  }
}
