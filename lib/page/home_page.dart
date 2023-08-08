import 'package:flutter/material.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../model/card_model.dart';
import '../controller/recipe_controller.dart';
import '../component/card.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: ColorConst.black,
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
                    itemCount: _recipe.length,
                    itemBuilder: (context, index) {
                      int reversedIndex = _recipe.length - 1 - index;
                      return CardComponent(
                        recipe: _recipe[reversedIndex],
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.arrow_left_outlined,
              ),
              Icon(
                Icons.add_circle_outline,
              ),
              SvgPicture.asset(
                'assets/images/bottle.svg', // SVG画像のパスを指定
                width: 100, // 画像の幅を調整
                height: 100, // 画像の高さを調整
              ),
              Icon(
                Icons.arrow_right_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

//カードウィジェット
}
