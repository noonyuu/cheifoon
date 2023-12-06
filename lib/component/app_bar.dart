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
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/silver.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: BorderedText(
              strokeWidth: 2.0,
              strokeColor: ColorConst.paleYellow,
              child: Text(
                title,
                style: GoogleFonts.kellySlab(
                  color: Colors.white,
                  letterSpacing: 6.0,
                  fontSize: fontSize(size),
                  fontWeight: FontWeight.bold,
                ),
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
