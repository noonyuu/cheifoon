import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../constant/color_constant.dart';
import '../constant/layout.dart';
import '../model/user_bottle/user_bottle_model.dart';
import 'alert.dart';

class BottleComponent extends StatelessWidget {
  final UserBottle bottle;
  final Function onDeletePressed;
  final double height;
  final double width;

  // コンストラクタを修正
  const BottleComponent({
    Key? key,
    required this.bottle,
    required this.onDeletePressed,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _bottle(context); // _bottleメソッドを呼び出す
  }

  Widget _bottle(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig(); // sizeConfigを初期化
    sizeConfig.init(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialogs(
                  bottleTitle: bottle.seasoning_name,
                  bottleId: bottle.seasoning_id,
                  onDeletePressed: onDeletePressed,
                );
              },
            );
          },
          child: Image.asset(
            'assets/buttle.png',
            width: sizeConfig.screenWidth * width,
            height: sizeConfig.screenHeight * height,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(bottom: sizeConfig.screenHeight * height * 0.2, child: _tag(context)), // _tagメソッドを呼び出す
      ],
    );
  }

  Widget _tag(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig(); // sizeConfigを再度初期化
    sizeConfig.init(context);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogs(
              bottleTitle: bottle.seasoning_name,
              bottleId: bottle.seasoning_id,
              onDeletePressed: onDeletePressed,
            );
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: sizeConfig.screenWidth * 0.08,
        height: sizeConfig.screenHeight * height * 0.3,
        decoration: const BoxDecoration(
          color: ColorConst.tag,
        ),
        child: bottle.seasoning_name.length > 4
            ? Marquee(
                text: bottle.seasoning_name,
                blankSpace: 20,
                style: TextStyle(fontSize: sizeConfig.screenWidth * 0.02),
                velocity: 10,
              )
            : Text(
                bottle.seasoning_name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: sizeConfig.screenWidth * 0.02),
              ),
      ),
    );
  }
}
