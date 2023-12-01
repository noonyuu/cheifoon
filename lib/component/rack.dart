import 'package:flutter/material.dart';

import '../constant/layout.dart';
import '../model/user_bottle/user_bottle_model.dart';
import 'bottle.dart';

class Seasoning extends StatelessWidget {
  final Function() notifyParent;
  final List<UserBottle> bottlePost;
  final double height;
  final double width;
  final double bottomPadding;
  final double bottleHeight;
  const Seasoning({super.key, required this.notifyParent, required this.bottlePost, required this.height, required this.width, required this.bottomPadding, required this.bottleHeight});

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    return SizedBox(
      width: sizeConfig.screenWidth * width,
      height: sizeConfig.screenHeight * height,
      child: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/rack.png',
              width: sizeConfig.screenWidth * width,
              height: sizeConfig.screenHeight * height,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(width * 0.1, 0, 0, 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: sizeConfig.screenWidth * 0.15,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: sizeConfig.screenHeight * bottomPadding),
                          child: Row(
                            children: List.generate(bottlePost.length, (index) {
                              return Row(
                                children: [
                                  BottleComponent(
                                    key: UniqueKey(), // ここで UniqueKey を使用して異なるキーを持つインスタンスを生成
                                    bottle: bottlePost[index],
                                    onDeletePressed: () {
                                      notifyParent();
                                    },
                                    height: bottleHeight,
                                    width: 0.08,
                                  ),
                                  Container(
                                    width: sizeConfig.screenWidth * 0.05,
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
