import '../constant/color_constant.dart';
import '../page/addalert.dart';

class AppBarComponentWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final bool isInfoIconEnabled;
  static String filePath = '';

	@@ -21,26 +22,43 @@ class AppBarComponentWidget extends StatefulWidget implements PreferredSizeWidge
  @override
  _AppBarComponentWidgetState createState() => _AppBarComponentWidgetState();
}

class _AppBarComponentWidgetState extends State<AppBarComponentWidget> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(96.0),
      child:
        // 元のやつ(画像ver.)
        // AppBar(
        //   // backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   flexibleSpace: Stack(
        //     children: [
        //       Positioned.fill(
        //         child: SvgPicture.asset(
        //           'assets/images/appbar.svg',
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // テキストver(真ん中にならない。辺にスペース取られてる。だからと言ってaddalertのappbar消したらダメ。)
        AppBar(
          title: Center(
            child: Text(
              'Add Recipe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorConst.black,
              ),
            ),
          ),
          backgroundColor: ColorConst.background,
        ),
    );
  }
}