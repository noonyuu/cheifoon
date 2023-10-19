import 'package:flutter/material.dart';
import 'dart:math';
import 'package:marquee/marquee.dart';

//page import
import 'package:sazikagen/constant/color_constant.dart';
import '../model/recipe_model.dart';
import '../page/sendseasoning.dart';
import 'package:google_fonts/google_fonts.dart'; //Google font

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
    double hightSize = MediaQuery.of(context).size.height * 0.2;
    double widthSize = MediaQuery.of(context).size.width * 0.4;

    return GestureDetector(
      onTap: () {
        // print('${_recipe}');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Send(recipe: _recipe)));
      },
      child: InkWell(
          child: Stack(
        children: [
          Container(
            height: hightSize,
            child: Image.asset('assets/new_img/memo.png'),
          ),
          Positioned(
            top: 35,
            left: 25,
            child: Column(
              children: [
                Container(
                  transform: Matrix4.rotationZ(-14 * pi / 180),
                  //料理の写真の大きさ
                  height: hightSize * 0.4,
                  width: widthSize * 0.5,
                  child: ClipRRect(
                    child: Image.memory(_recipe.imagePath),
                  ),
                ),

                //料理名

                Container(
                  transform: Matrix4.rotationZ(-12 * pi / 180),
                  width: widthSize * 0.5,
                  height: hightSize * 0.2,
                  alignment: Alignment.center,
                  child: Container(
                    width: widthSize * 3,
                    height: hightSize * 0.2,
                    child: _recipe.title.length > 10
                        ? Marquee(
                            text: _recipe.title,
                            blankSpace: 30,
                            style: GoogleFonts.slacksideOne(fontSize: 15),
                            velocity: 10,
                          )
                        : Text(
                            _recipe.title,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.slacksideOne(fontSize: 20),
                          ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
  // Widget _Recipe(BuildContext context) {
  //   double cardSize = MediaQuery.of(context).size.width / 2;

  //   return GestureDetector(
  //     onTap: () {
  //       // print('${_recipe}');
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => Send(recipe: _recipe)));
  //     },
  //     child: InkWell(
  //       child: Card(
  //         color: ColorConst.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(30),
  //         ),
  //         child: Container(
  //           height: cardSize,
  //           width: cardSize,
  //           decoration: BoxDecoration(
  //             border: Border.all(
  //               color: ColorConst.mainColor, // 枠線の色
  //               width: 5.0, // 枠線の幅
  //             ),
  //             borderRadius: BorderRadius.circular(30),
  //           ),
  //           child: Column(
  //             children: [
  //               Container(
  //                 width: cardSize,
  //                 height: cardSize * 0.6,
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(24.0),
  //                     topRight: Radius.circular(24.0),
  //                   ),
  //                   child: FittedBox(
  //                     child: Image.memory(_recipe.imagePath),
  //                     fit: BoxFit.fill,
  //                   ),
  //                   // child: Image.asset('assets/images/appBar.png'),
  //                 ),
  //               ),
  //               Container(
  //                 height: cardSize * 0.25,
  //                 alignment: Alignment.center,
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.only(
  //                     bottomLeft: Radius.circular(24.0),
  //                     bottomRight: Radius.circular(24.0),
  //                   ),
  //                   child: Container(
  //                     alignment: Alignment.center, // text center
  //                     color: ColorConst.background,
  //                     // height: cardSize * 0.20,
  //                     width: cardSize * 0.8,
  //                     child: Text('${_recipe.title}'),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
