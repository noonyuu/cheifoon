import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sazikagen/page/login.dart';

import 'constant/color_constant.dart';
import 'model/insert_bottle_model.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true; // ウィジェットの境界を表示
  // debugPaintLayerBordersEnabled = true; // レイヤーの境界を表示
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<InsertBottleModel>(
          create: (context) => InsertBottleModel(),
        ),
        // ChangeNotifierProvider<>(create: create)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LogInScreen(),
        // home: const BranchPoint(),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.kellySlabTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
      ),
    );
  }
}