import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sazikagen/page/home_page.dart';

final countProvider = StateProvider((ref) => 0);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true; // ウィジェットの境界を表示
  // debugPaintLayerBordersEnabled = true; // レイヤーの境界を表示
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
