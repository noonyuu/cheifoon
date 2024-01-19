import 'validator.dart';

class MaxLengthValidator implements Validator<String> {
  final int maxLength;

  MaxLengthValidator(this.maxLength);

  @override
  bool validate(value) => value.length <= maxLength;

  @override
  String getMessage() => '$maxLength${"文字以内で入力してください"}';
}
