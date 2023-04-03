

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfe/theme/theme.dart';

import 'constants.dart';



class MyButton extends StatelessWidget
{

  final String label ; 
  final Function() ontap ; 
const MyButton({Key? key, required this.label , required this.ontap }): super(key: key);

@override 

Widget build(BuildContext context){
  Size size = MediaQuery.of(context).size;
  return InkWell(
    onTap: ontap ,
    borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: primaryclr,
        ),

        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
        ),
      ),
  );
}


}