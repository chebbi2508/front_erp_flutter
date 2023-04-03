import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/theme/theme.dart';

import 'package:http/http.dart' as http;

import '../models/activite.dart';

import 'dart:core';


class TaskTile extends StatelessWidget {
final  plannings ;
final  aactt ;
final  usss ;
TaskTile(this.plannings , this.aactt , this.usss) ;
 
 

@override 
Widget build(BuildContext context )
{  
  
   return Container(
     padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: _getBGClr(plannings.status),
    ),
    child: Row(children: [
      Expanded(child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(  usss ?? '' , 
          style: GoogleFonts.lato(
            fontSize: 16 , 
            fontWeight: FontWeight.bold ,
            color: Colors.white,
          )),


          Row(children: [
            Icon(
              Icons.access_time_rounded ,
              color:  Colors.grey[200],
              size: 18,
            ),
            SizedBox(height: 4,), 

          Text(
            plannings.start_time + '-'  + plannings.end_time , 
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 13 , color: Colors.grey.shade100)
            ),
          ),
          ],),
          
          SizedBox(height: 12,), 

          Text( aactt ?? ''
             , 
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 15 , color: Colors.grey)
            ),
          )
          
         
          
        ],
      )),
       Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(quarterTurns: 3 , 
          child : Text(plannings.date , 
          style:  GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 10 , 
            fontWeight:  FontWeight.bold , 
            color: Colors.white),
          ),)),
    ]),
    
       )
;

}
 

 _getBGClr(String status) {
   switch(status) {
     case 'enattend': 
     return bluishClr; 
     case 'active' : 
     return Colors.pink ; 
     case 'terminer' : 
     return Color.fromARGB(255, 250, 239, 140) ; 
     default: 
     return bluishClr ; 
   }
 }

}