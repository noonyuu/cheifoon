import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getRecipe(int id) async {
  print('sql recipe request');
  final response = await http.get(
    // Uri.parse('http://localhost:8081/recipe/view/$id'), // サーバーのエンドポイントを指定
    Uri.parse('http://192.168.0.12:8081/recipe/view/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  List<dynamic> responseData = [];
  if (response.statusCode == 200) {
    print('データが正常に登録されました');
    responseData = json.decode(response.body);
    List<Map<String, dynamic>> result = [];

    for (int i = 0; i < responseData.length; i++) {
      Map<String, dynamic> item = {};
      item['ID'] = responseData[i]['ID']; // IDが不要ならコメントアウト
      item['user_id'] = responseData[i]['user_id'];
      item['recipe_name'] = responseData[i]['recipe_name'];
      item['menu_image'] = responseData[i]['menu_image'];
      result.add(item);
    }
    return result;
  } else {
    print('エラー: ${response.statusCode}');
    print('レスポンス: ${response.body}');
  }
  return responseData;
}
