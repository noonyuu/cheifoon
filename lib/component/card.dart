import 'package:flutter/material.dart';

import '../constant/color_constant.dart';
import '../constant/layout.dart';
import '../model/recipe/recipe_model.dart';
import '../page/send_seasoning.dart';

class CardComponent extends StatelessWidget {
  final Recipe _recipe;
  const CardComponent({
    Key? key,
    required Recipe recipe,
  }) : _recipe = recipe;

  @override
  Widget build(BuildContext context) {
    return _Recipe(context);
  }

  Widget _Recipe(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Send(recipe: _recipe)));
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double containerHeight = constraints.maxHeight;
          double containerWidth = constraints.maxWidth;

          return Card(
            margin: EdgeInsets.all(0), // これがないとmarginができてしまう
            // color: ColorConst.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: containerHeight,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorConst.mainColor,
                  width: containerWidth * 0.02,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    child: Image.memory(
                      height: containerHeight * 0.8 - (containerHeight * 0.04), // 枠の太さ分を引く
                      width: containerWidth,
                      _recipe.menu_image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: Container(
                      height: containerHeight * 0.2,
                      alignment: Alignment.center,
                      color: ColorConst.background,
                      child: Text(_recipe.recipe_name),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
