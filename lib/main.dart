import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'page/branch_point.dart';

final countProvider = StateProvider((ref) => 0);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true; // ウィジェットの境界を表示
  // debugPaintLayerBordersEnabled = true; // レイヤーの境界を表示
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BranchPoint());
  }
}
