import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:google_fonts/google_fonts.dart'; //Google font

import 'package:sazikagen/constant/color_constant.dart';
import '../model/bottle_model.dart';
import 'alert.dart';

class BottleComponent extends StatefulWidget {
  final BottleModel _bottle;
  final Function onDeletePressed; // onDeletePressed をフィールドとして追加

  // コンストラクタを修正
  const BottleComponent({
    Key? key,
    required BottleModel bottle,
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
                  bottleTitle: widget._bottle.bottleTitle,
                  bottleId: widget._bottle.bottleId,
                  onDeletePressed: widget.onDeletePressed,
                );
              },
            );
          },
          child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: 60,
              child: Image.asset('assets/new_img/bottle.png')),
        ),
        Positioned(left: 10, top: 62, child: _tag()),
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
              bottleTitle: widget._bottle.bottleTitle,
              bottleId: widget._bottle.bottleId,
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
          color: newColorConst.tag,
          border: Border.all(
            color: newColorConst.mainColor, // 枠線の色
            width: 2.0,
            // 枠線の幅
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget._bottle.bottleTitle.length > 4
            ? Marquee(
                text: widget._bottle.bottleTitle,
                blankSpace: 20,
                style: GoogleFonts.notoSansJp(fontSize: 10),
                velocity: 10,
              )
            : Text(
                widget._bottle.bottleTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansJp(fontSize: 10),
              ),
      ),
    );
  }
}
