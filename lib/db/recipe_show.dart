import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'endPoint.dart';

Future<List<dynamic>> getRecipe(int id) async {
  // TODO: UserIDを引数にする
  Uri url = Uri.parse('http://${get_end_point()}:8081/recipe/view/1');
  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  List<dynamic> responseData = [];
  if (response.statusCode == 200) {
    responseData = json.decode(response.body);
    List<Map<String, dynamic>> result = [];

    for (int i = 0; i < responseData.length; i++) {
      Map<String, dynamic> item = {};
      item['ID'] = responseData[i]['ID'];
      item['user_id'] = responseData[i]['user_id'];
      item['recipe_name'] = responseData[i]['recipe_name'];
      item['menu_image'] = responseData[i]['menu_image'];

      // recipe_imageの取得
      final imageUrl = Uri.parse('http://${get_end_point()}:8081/getImage/${Uri.encodeFull('${item['menu_image']}')}');
      final responseImage = await http.get(imageUrl);
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
