import 'validator.dart';

class RequiredValidator implements Validator<String?> {
  @override
  bool validate(String? value) {
    if (value == null) {
      return false;
    }

    return value.trim().isNotEmpty;
  }

  @override
  String getMessage() => "必須項目です";
  
  @override
  Future<bool> validateAwait(String? value) {
    return Future.value(validate(value));
  }
}
