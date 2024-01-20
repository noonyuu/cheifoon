abstract class Validator<T> {
  bool validate(T value);

  Future<bool> validateAwait(T value);

  String getMessage();
}
