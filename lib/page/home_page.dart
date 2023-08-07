import 'package:flutter/material.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../model/card_model.dart';
import '../controller/recipe_controller.dart';
import '../component/card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardModel> _recipe = [];

  @override
  void initState() {
    super.initState();
    _recipe = RecipeController().recipe; // RecipeControllerからデータを取得
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
                'assets/images/apptitle.png',
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
          Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 列の数
                  ),
                  itemCount: _recipe.length,
                  itemBuilder: (context, index) {
                    int reversedIndex = _recipe.length - 1 - index;
                    return CardComponent(
                      recipe: _recipe[reversedIndex],
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Icon(
                Icons.arrow_left_outlined,
              ),
              Icon(
                Icons.add_circle_outline,
              ),
              Image.asset('assets/images/bottle.png'),
              Icon(
                Icons.arrow_right_outlined,
              ),
            ],
          ),
        ));
  }

//カードウィジェット
}
