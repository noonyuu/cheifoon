import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'endPoint.dart';

Future<List<dynamic>> getRecipe(int id) async {
  Uint8List uint8ListFromBase64(String base64String) {
    List<int> bytes = base64.decode(base64String);
    return Uint8List.fromList(bytes);
  }

  print('sql recipe request');
  final response = await http.get(
    Uri.parse('http://${get_end_point()}:8081/recipe/view/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  final imageUrl = Uri.parse('http://${get_end_point()}:8081/getImage/${Uri.encodeFull('110.jpg')}');
  final responseImage = await http.get(imageUrl);
  print('sql recipe response: ${responseImage.bodyBytes}');

  List<dynamic> responseData = [];
  if (response.statusCode == 200) {
    print('データが正常に登録されました');
    responseData = json.decode(response.body);
    List<Map<String, dynamic>> result = [];

    for (int i = 0; i < responseData.length; i++) {
      Map<String, dynamic> item = {};
      item['ID'] = responseData[i]['ID'];
      item['user_id'] = responseData[i]['user_id'];
      item['recipe_name'] = responseData[i]['recipe_name'];

      // 画像データの取得
      final Uint8List imageData = responseImage.bodyBytes;
      item['menu_image'] = imageData;

      result.add(item);
    }
    return result;
  } else {
    print('エラー: ${response.statusCode}');
    print('レスポンス: ${response.body}');
  }
  return responseData;
}
