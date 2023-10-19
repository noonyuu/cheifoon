import 'dart:convert';
import 'package:http/http.dart' as http;

import 'endPoint.dart';

Future<http.Response> postMenu(menu) async {
  final response = await http.post(
    Uri.parse('http://${get_end_point()}:8081/menu/add'), // サーバーのエンドポイントを指定
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(menu),
  );
  print(jsonEncode(menu));
  if (response.statusCode == 201) {
    print('データが正常に登録されました');
  } else {
    print('munuエラー: ${response.statusCode}');
    print('レスポンス: ${response.body}');
  }
  return response;
}

// https://qiita.com/u-dai/items/09c92f5ca7c9bd2fca80
// https://qiita.com/Sekky0905/items/447efa04a95e3fec217f
// https://zenn.dev/a_ichi1/articles/4b113d4c46857a
// https://palettemaker.com/app
