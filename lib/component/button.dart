import 'package:flutter/material.dart';
import 'package:sazikagen/constant/color_constant.dart';

import '../constant/layout.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonTitle,
    required this.height,
    required this.width,
    required this.textSize,
    required this.onPressed,
    // required this.pageName,
  });

  final String buttonTitle;
  final double height;
  final double width;
  final double textSize;
  final Function onPressed;
  // final Widget pageName;

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);

    return OutlinedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(sizeConfig.screenWidth * width, sizeConfig.screenHeight * height),
        foregroundColor: ColorConst.black,
        backgroundColor: ColorConst.mainColors,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(
          color: ColorConst.black,
          width: 1,
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(
        buttonTitle,
        style: TextStyle(fontSize: textSize),
      ),
    );
  }
}

// ボタンサイズ
class ButtonSize {
  final double height;
  final double width;
  final double textSize;

  ButtonSize({
    required this.height,
    required this.width,
    required this.textSize,
  });
}

ButtonSize buttonSize(PhoneSize size) {
  return (size.buttonSize);
}

extension ButtonSizeExtension on PhoneSize {
  ButtonSize get buttonSize => switch (this) {
        PhoneSize.verticalMobile => ButtonSize(
            height: 0.04,
            width: 0.1,
            textSize: 10,
          ),
        PhoneSize.horizonMobile => ButtonSize(
            height: 0.05,
            width: 0.15,
            textSize: 20,
          ),
        PhoneSize.verticalTablet => ButtonSize(
            height: 0.05,
            width: 0.15,
            textSize: 20,
          ),
        PhoneSize.horizonTablet => ButtonSize(
            height: 0.08,
            width: 0.15,
            textSize: 20,
          )
      };
}
