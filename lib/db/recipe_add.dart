import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'endPoint.dart';

// Future<String> postRecipe(int userId, String recipe, File file) async {
// String image = file.toString();
// print(recipe);

// String url = 'http://${get_end_point()}:8081/recipe/add';

// // リクエストヘッダーにユーザーIDを追加
// Map<String, dynamic> headers = {'user_id': userId.toString()};

// FormData formData = FormData.fromMap({
//   "recipe_name": recipe,
//   "menu_image": await MultipartFile.fromFile(file.path),
// });

// try {
//   Response response = await Dio().post(
//     url,
//     data: formData,
//     options: Options(headers: headers),
//   );
//   print(response);
//   return response.data;
// } catch (e) {
//   print(e);
// }

// final response = await http.post(
//   Uri.parse('http://${get_end_point()}:8081/recipe/add'),
//   headers: <String, String>{
//     'Content-Type': 'application/json; charset=UTF-8',
//   },
//   body: jsonEncode(<String, dynamic>{
//     "user_id": userId,
//     "recipe_name": recipe,
//     "menu_image": file, // base64エンコードされた画像データ
//   }),
// );

// if (response.statusCode == 201) {
//   print('データが正常に登録されました');
//   // Map<String, dynamic> responseData = json.decode(response.body);
//   String responseData = response.body;
//   // int recipeId = responseData['id'];
//   print('responseData: $responseData');
//   return responseData;
// } else {
//   print('recipeAddエラー: ${response.statusCode}');
//   print('recipeAddレスポンス: ${response.body}');
// }
// return "0";
// }

// // バイナリデータを取得
// List<int> imageBytes = file.readAsBytesSync();
// // レシピ名とユーザID送信用のデータを作成
// Map<String, String> formData = {
//   "user_id": userId.toString(),
//   "recipe_name": recipe,
// };
// // エンドポイント
// var url = Uri.parse('http://${get_end_point()}:8081/recipe/add');

// var request = http.MultipartRequest('POST', url);

// formData.forEach((key, value) {
//   request.fields[key] = value;
// });

// // 画像データを追加
// var multipartFile = http.MultipartFile.fromBytes(
//   'menu_image',
//   imageBytes,
//   filename: '$recipe.jpg',
// );

// request.files.add(multipartFile);

// var response = await request.send();
// if (response.statusCode == 200) {
//   print('画像とデータがアップロードされました');
//   return response;
// } else {
//   print('アップロードに失敗しました: ${response.statusCode}');
//   return null;
// }

Future<int> postRecipe(int userId, String recipe, File file) async {
  // エンドポイント
  final url = Uri.parse('http://${get_end_point()}:8081/recipe/add');
  final request = http.MultipartRequest('POST', url);

  // フォームデータとしてuserIdとrecipeを追加
  request.fields['user_id'] = userId.toString();
  request.fields['recipe_name'] = recipe;

  // 画像ファイルを追加
  final fileField = await http.MultipartFile.fromPath('menu_image', file.path);
  request.files.add(fileField);
  final response = await request.send();
  if (response.statusCode == 200) {
    print('Image uploaded successfully.');
    final responseString = await response.stream.bytesToString();
    print("String:${responseString}");

    final List<String> responseParts = responseString.split('\n');
    // メッセージ部分を取得
    final message = responseParts[0];
    // JSON部分を取得
    final jsonPart = responseParts[1];

    print("Message: $message");
    print("JSON: $jsonPart");

    final responseData = json.decode(jsonPart);
    return int.parse(responseData["id"]);
  } else {
    print('Failed to upload image.');
    return 0;
  }
}
