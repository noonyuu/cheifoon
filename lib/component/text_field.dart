import 'package:flutter/material.dart';

import '../constant/color_constant.dart';
import '../validator/validator.dart';

class TextView extends StatefulWidget {
  final String labelText;
  final List<Validator> validator;
  final Function controller;
  final Function setIsValid;
  final bool secret;

  const TextView({Key? key, required this.labelText, required this.validator, required this.controller, required this.secret, required this.setIsValid}) : super(key: key);

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  /// エラーテキスト
  String? _errorText;

  void _validate(String value) {
    widget.controller(value);
    final result = widget.validator.where((validator) => validator.validate(value) == false).toList();
    if (result.isNotEmpty) {
      _errorText = result.first.getMessage();
      widget.setIsValid(false);
    } else {
      _errorText = null;
      widget.setIsValid(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          onChanged: (String value) {
            _validate(value);
          },
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: ColorConst.grey,
            ),
            // hintText: labelText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorConst.grey,
              ),
            ),
          ),
          obscureText: widget.secret,
          // controller: widget.controller(),
        ),
        _errorText != null
            ? Text(
                _errorText!,
                style: const TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
              )
            : const SizedBox()
      ],
    );
  }
}
