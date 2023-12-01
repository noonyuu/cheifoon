import 'package:flutter/material.dart';

import '../constant/layout.dart';

class AppBarComponentWidget extends StatelessWidget {
  const AppBarComponentWidget({super.key, required String title, required bool isInfoIconEnabled, required BuildContext context, Color? backgroundColor});

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
        ],
      ),
    );
  }
}
