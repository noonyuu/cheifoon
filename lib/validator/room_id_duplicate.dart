import 'dart:convert';

import 'package:sazikagen/validator/validator.dart';
import 'package:http/http.dart' as http;

import '../db/end_point.dart';

class RoomIdDuplicateValidator implements Validator<String?> {
  final String roomId;

  RoomIdDuplicateValidator(this.roomId);

  @override
  bool validate(String? value) {
    if (value == null) {
      return false;
    }

    return value.trim().isNotEmpty;
  }

  @override
  String getMessage() => '$roomId${"は既に使用されています"}';

  @override
  Future<bool> validateAwait(String? value) {
    return isDuplicate(roomId);
  }
}

Future<bool> isDuplicate(String roomId) async {
  Uri url = Uri.parse('http://${getEndPoint()}/roomId/duplicateCheck/$roomId');
  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode != 200) {
    return false;
  }
  final bool data = json.decode(response.body);
  return data;
}
