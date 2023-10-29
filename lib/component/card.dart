import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../model/recipe/recipe_model.dart';
import '../page/sendseasoning.dart';

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
    double cardSize = MediaQuery.of(context).size.width / 2;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Send(recipe: _recipe)));
      },
      child: InkWell(
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
                color: ColorConst.mainColor,
                width: 5.0,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Container(
                  width: cardSize,
                  height: cardSize * 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                    child: Image.memory(
                      _recipe.menu_image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: cardSize * 0.25,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24.0),
                      bottomRight: Radius.circular(24.0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      color: ColorConst.background,
                      width: cardSize * 0.8,
                      child: Text(_recipe.recipe_name),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
