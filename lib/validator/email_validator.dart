import 'validator.dart';

class EmailValidator implements Validator<String> {
  final String email;

  EmailValidator(this.email);

  @override
  bool validate(value) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

  @override
  String getMessage() => "正しい形式で入力してください";
}
