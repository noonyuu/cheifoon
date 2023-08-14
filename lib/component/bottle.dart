import 'package:flutter/material.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../model/bottle_model.dart';

class BottleComponent extends StatelessWidget {
  final BottleModel _bottle;
  const BottleComponent({
    Key? key,
    required BottleModel bottle,
  }) : _bottle = bottle;

  @override
  Widget build(BuildContext context) {
    return _Bottle();
  }

  Widget _Bottle() {
    return Stack(
      children: [
        Image.asset('assets/images/bottle.png'),
        Positioned(left: 8, top: 30, child: _tag()),
      ],
    );
  }

  Widget _tag() {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 20,
      decoration: BoxDecoration(
        color: ColorConst.tag,
        border: Border.all(
          color: ColorConst.mainColor, // 枠線の色
          width: 2.0,
          // 枠線の幅
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '${_bottle.bottleTitle}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10),
      ),
    );
  }
}
