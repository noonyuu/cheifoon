import 'package:flutter/material.dart';

import '../constant/layout.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonTitle,
    required this.height,
    required this.width,
    required this.textSize,
    // required this.pageName,
  });

  final String buttonTitle;
  final double height;
  final double width;
  final double textSize;
  // final Widget pageName;

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);

    return OutlinedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(sizeConfig.screenWidth * width, sizeConfig.screenHeight * height),
        foregroundColor: Colors.black,
        backgroundColor: null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
      onPressed: () {},
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
            height: 0.05,
            width: 0.15,
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
