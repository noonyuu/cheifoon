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
    return _Recipe();
  }

  Widget _Recipe() {
    return InkWell(
      child: Card(
        color: ColorConst.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          height: 140,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorConst.mainColor, // 枠線の色
              width: 5.0, // 枠線の幅
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                child: Image.asset('${_recipe.imagePath}'),
              ),
              const SizedBox(
                height: 5,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.0),
                    bottomRight: Radius.circular(24.0),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    color: ColorConst.background,
                    height: 51,
                    width: 170,
                    child: Text('${_recipe.title}'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}