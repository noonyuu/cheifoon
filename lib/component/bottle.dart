import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:sazikagen/constant/color_constant.dart';
import 'package:sazikagen/model/user_bottle/user_bottle_model.dart';

import 'alert.dart';

class BottleComponent extends StatefulWidget {
  final UserBottle _bottle;
  final Function onDeletePressed; // onDeletePressed をフィールドとして追加

  // コンストラクタを修正
  const BottleComponent({
    Key? key,
    required UserBottle bottle,
    required this.onDeletePressed, // コンストラクタで onDeletePressed を受け取る
  })  : _bottle = bottle, // _bottle フィールドを初期化
        super(key: key);

  @override
  _BottleComponentState createState() => _BottleComponentState();
}

class _BottleComponentState extends State<BottleComponent> {
  @override
  Widget build(BuildContext context) {
    return _Bottle();
  }

  Widget _Bottle() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialogs(
                  bottleTitle: widget._bottle.seasoning_name,
                  bottleId: widget._bottle.seasoning_id,
                  onDeletePressed: widget.onDeletePressed,
                );
              },
            );
          },
          child: Image.asset('assets/images/bottle.png'),
        ),
        Positioned(left: 8, top: 30, child: _tag()),
      ],
    );
  }

  Widget _tag() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogs(
              bottleTitle: widget._bottle.seasoning_name,
              bottleId: widget._bottle.seasoning_id,
              onDeletePressed: widget.onDeletePressed,
            );
          },
        );
      },
      child: Container(
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
        child: widget._bottle.seasoning_name.length > 4
            ? Marquee(
                text: widget._bottle.seasoning_name,
                blankSpace: 20,
                style: const TextStyle(fontSize: 10),
                velocity: 10,
              )
            : Text(
                widget._bottle.seasoning_name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
      ),
    );
  }
}
