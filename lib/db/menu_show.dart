import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getMenu(int recipeId) async {
  final response = await http.get(
    Uri.parse('http://192.168.0.12:8081/menu/view/1/$recipeId'),
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
      item['recipe_id'] = responseData[i]['recipe_id'];
      item['user_id'] = responseData[i]['user_id'];
      item['seasoning_id'] = responseData[i]['seasoning_id'];
      item['table_spoon'] = responseData[i]['table_spoon'];
      item['tea_spoon'] = responseData[i]['tea_spoon'];
      result.add(item);
    }
    return result;
  } else {
    print('エラー: ${response.statusCode}');
    print('レスポンス: ${response.body}');
  }
  return responseData;
}
// final List<dynamic> data = json.decode(response.body);
// List<Map<dynamic, dynamic>> result = List<Map<dynamic, dynamic>>.from(data);
