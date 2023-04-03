import 'package:flutter/material.dart';
import 'package:pfe/components/input_container.dart';
import 'package:pfe/constants.dart';

import '../theme/colors.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({
    Key? key,
    required this.hint
  }) : super(key: key);

  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        cursorColor: kSeconderyColor,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: kSeconderyColor),
          hintText: hint,
          border: InputBorder.none
        ),
      ));
  }
}