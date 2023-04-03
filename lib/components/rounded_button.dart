
import 'package:flutter/material.dart';
import 'package:pfe/constants.dart';

import '../theme/colors.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.ontap ,
  }) : super(key: key);

  final String title;
  final Function() ontap ; 

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 50,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kSeconderyColor,
        ),

        padding:const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
        ),
      ),
    );
  }
}