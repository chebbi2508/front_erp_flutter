import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pink = Color(0xFFff4667);
const Color white = Colors.white ;
const Color primaryclr = bluishClr ;
const Color dark = Color(0xFF121212);
const Color darkheader = Color(0xFF424242);




class mineColors  {
static final light = ThemeData(
 backgroundColor: Colors.white ,
 primaryColor:  primaryclr,
 brightness: Brightness.light
);



}
TextStyle get subheading{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24 , 
      fontWeight: FontWeight.bold
    )
  );
}
TextStyle get heading{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 30 , 
      fontWeight: FontWeight.bold
    )
  );}

  TextStyle get titleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
     
      fontSize: 20 , 
      fontWeight: FontWeight.w900,
      color: Colors.black ,
    )
  );}

   TextStyle get subtitleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
     
      fontSize: 14 , 
      fontWeight: FontWeight.w400,
          color: Colors.grey ,
    )
  );}