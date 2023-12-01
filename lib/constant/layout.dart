// デバイス幅設定
import 'package:flutter/material.dart';

const mobileWidth = 600;  //600pxまで
const mobileHeight = 500; //500pxまで
const tabletWidth = 1100; //1100pxまで

enum PhoneSize {
  verticalMobile,
  horizonMobile,
  verticalTablet,
  horizonTablet,
}

class SizeConfig {
  late MediaQueryData _mediaQueryData;
  late Orientation orientation;
  late double screenWidth;
  late double screenHeight;
  // late double blockSizeHorizontal;
  // late double blockSizeVertical;

  late double _safeAreaHorizontal;
  late double _safeAreaVertical;
  // late double safeBlockHorizontal;
  // late double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    // blockSizeHorizontal = screenWidth / 100;
    // blockSizeVertical = screenHeight / 100;
    orientation = MediaQuery.of(context).orientation;
  }
}
