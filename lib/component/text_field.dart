import 'package:flutter/material.dart';

import '../constant/color_constant.dart';
import '../constant/layout.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final double height;
  final double width;
  final double labelSize;
  final double hintSize;
  final double textField;
  final Function onChanged;

  const CustomTextField(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.obscureText,
      required this.height,
      required this.width,
      required this.labelSize,
      required this.hintSize,
      required this.textField,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? inputRecipe;

    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: sizeConfig.screenWidth * width,
          height: sizeConfig.screenHeight * height,
          child: TextField(
            style: TextStyle(fontSize: textField),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(color: ColorConst.mainColor, fontSize: labelSize),
              hintText: hintText,
              hintStyle: TextStyle(color: ColorConst.hintColor, fontSize: hintSize),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: ColorConst.mainColor,
                ),
              ),
              contentPadding: EdgeInsets.all(textField),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: ColorConst.mainColor,
                ),
              ),
            ),
            obscureText: obscureText,
            onChanged: (value) {
              onChanged();
            },
          ),
        ),
      ],
    );
  }
}

// フィールドのサイズ
class FieldSize {
  final double height;
  final double width;
  final double labelSize;
  final double hintSize;
  final double textField;

  FieldSize({
    required this.height,
    required this.width,
    required this.labelSize,
    required this.hintSize,
    required this.textField,
  });
}

FieldSize fieldSize(PhoneSize size) {
  return (size.fieldSize);
}

extension FieldSizeExtension on PhoneSize {
  FieldSize get fieldSize => switch (this) {
        PhoneSize.verticalMobile => FieldSize(
            height: 0.05,
            width: 0.5,
            labelSize: 20,
            hintSize: 10,
            textField: 20,
          ),
        PhoneSize.horizonMobile => FieldSize(
            height: 0.1,
            width: 0.3,
            labelSize: 20,
            hintSize: 10,
            textField: 30,
          ),
        PhoneSize.verticalTablet => FieldSize(
            height: 0.07,
            width: 0.3,
            labelSize: 20,
            hintSize: 20,
            textField: 30,
          ),
        PhoneSize.horizonTablet => FieldSize(
            height: 0.2,
            width: 0.3,
            labelSize: 20,
            hintSize: 20,
            textField: 30,
          ),
      };
}
