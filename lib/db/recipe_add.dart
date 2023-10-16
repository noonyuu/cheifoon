import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int> postRecipe(int userId, String recipe, String imagePath) async {
  print(imagePath);
  print(recipe);
  final response = await http.post(
    Uri.parse('http://192.168.0.12:8081/recipe/add'), // サーバーのエンドポイントを指定
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": userId,
      "recipe_name": recipe,
      "menu_image": imagePath,
    }),
  );

  if (response.statusCode == 201) {
    print('データが正常に登録されました');
    Map<String, dynamic> responseData = json.decode(response.body);
    int recipeId = responseData['id'];
    return recipeId;
  } else {
    print('recipeAddエラー: ${response.statusCode}');
    print('recipeAddレスポンス: ${response.body}');
  }
  return 0;
}
