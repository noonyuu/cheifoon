import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'endPoint.dart';

Future<String> postRecipe(int userId, String recipe, Uint8List imageBytes) async {
  String image = imageBytes.toString();
  print(recipe);
  final response = await http.post(
    Uri.parse('http://${get_end_point()}:8081/recipe/add'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": userId,
      "recipe_name": recipe,
      "menu_image": image, // base64エンコードされた画像データ
    }),
  );

  if (response.statusCode == 201) {
    print('データが正常に登録されました');
    // Map<String, dynamic> responseData = json.decode(response.body);
    String responseData = response.body;
    // int recipeId = responseData['id'];
    print('responseData: $responseData');
    return responseData;
  } else {
    print('recipeAddエラー: ${response.statusCode}');
    print('recipeAddレスポンス: ${response.body}');
  }
  return "0";
}
