import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/color_constant.dart';
import '../constant/layout.dart';

class AppBarComponentWidget extends StatelessWidget {
  final String title;
  final bool isInfoIconEnabled;
  final BuildContext context;
  final Color? backgroundColor;
  final PhoneSize size;

  const AppBarComponentWidget({
    Key? key,
    required this.title,
    required this.isInfoIconEnabled,
    required this.context,
    this.backgroundColor,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      flexibleSpace: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: ColorConst.mainColors,
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 6.0,
                fontSize: fontSize(size),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

double fontSize(PhoneSize size) {
  return (size.fontSize);
}

extension FontSizeExtension on PhoneSize {
  double get fontSize => switch (this) {
        PhoneSize.verticalMobile => 25,
        PhoneSize.horizonMobile => 25,
        PhoneSize.verticalTablet => 50,
        PhoneSize.horizonTablet => 50,
      };
}

double appBar(PhoneSize size) {
  return (size.appBarSize);
}

extension AppBarSize on PhoneSize {
  double get appBarSize => switch (this) {
        PhoneSize.verticalMobile => 0.07,
        PhoneSize.horizonMobile => 0.1,
        PhoneSize.verticalTablet => 0.1,
        PhoneSize.horizonTablet => 0.1,
      };
}
