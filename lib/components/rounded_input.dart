import 'package:flutter/material.dart';
import 'package:pfe/components/input_container.dart';
import 'package:pfe/constants.dart';

import '../theme/colors.dart';

class RoundedInput extends StatelessWidget {
   RoundedInput({
    Key? key,
    required this.icon,
    required this.color,
    required this.hint, 
    required this.controller ,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final Color color;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextFormField(
        cursorColor: color,
        controller: controller,
        keyboardType :  TextInputType.emailAddress, 
                decoration: InputDecoration(
          icon: Icon(icon, color: color),
          hintText: hint,
          border: InputBorder.none
        ),
      ));
  }
}

class RoundedPassInput extends StatelessWidget {
   RoundedPassInput({
    Key? key,
    required this.icon,
    required this.hint, 
    required this.controller ,
    required this.ontap ,
    required this.isHidden ,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final bool isHidden;
  final Function() ontap;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextFormField(
        cursorColor: kSeconderyColor,
        controller: controller,
        keyboardType :  TextInputType.none, 
                decoration: InputDecoration(
          icon: Icon(icon, color: kSeconderyColor),
          hintText: hint,
          suffixIcon: InkWell(
                onTap: ontap,
                child : Icon(
                  isHidden ? Icons.visibility : Icons.visibility_off,
                ),
                
              ),
          border: InputBorder.none
        ),
      ));
  }
}