import 'package:flutter/material.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../model/recipe_model.dart';

class CardComponent extends StatelessWidget {
  final RecipeModel _recipe;
  const CardComponent({
    Key? key,
    required RecipeModel recipe,
  }) : _recipe = recipe;
  @override
  Widget build(BuildContext context) {
    return _Recipe(context);
  }

  Widget _Recipe(BuildContext context) {
    double cardSize = MediaQuery.of(context).size.width / 2;
    return InkWell(
      child: Card(
        color: ColorConst.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          height: cardSize,
          width: cardSize,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorConst.mainColor, // 枠線の色
              width: 5.0, // 枠線の幅
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Container(
                height: cardSize * 0.6,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                  child: Image.asset('${_recipe.imagePath}'),
                  // child: Image.asset('assets/images/appBar.png'),
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.0),
                    bottomRight: Radius.circular(24.0),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    color: ColorConst.background,
                    height: cardSize * 0.3,
                    width: cardSize,
                    child: Text('${_recipe.title}'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
