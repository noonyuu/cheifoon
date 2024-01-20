import 'validator.dart';

class MinLengthValidator implements Validator<String> {
  final int minLength;

  MinLengthValidator(this.minLength);

  @override
  bool validate(value) => value.length >= minLength;

  @override
  String getMessage() => '$minLength${"文字以上で入力してください"}';

  @override
  Future<bool> validateAwait(String? value) {
    return Future.value(validate(value!));
  }
}
