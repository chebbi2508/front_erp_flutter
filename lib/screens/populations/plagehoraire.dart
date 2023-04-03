import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../input_filed.dart';
import 'package:day_picker/day_picker.dart';


class PlageHoraireScreen extends StatefulWidget {
  late int idpopulation ;

    PlageHoraireScreen( this.idpopulation) ;

  @override
  State<PlageHoraireScreen> createState() => _PlageHoraireScreenState();
}

class _PlageHoraireScreenState extends State<PlageHoraireScreen> {
     TimeOfDay _endTime = TimeOfDay.now();

     TimeOfDay _startTime = TimeOfDay.now();

      // ignore: prefer_final_fields
      List<DayInWeek> _days = [
    DayInWeek(
      "L",
    ),
    DayInWeek(
      "M",
    ),
    DayInWeek(
      "M",
    ),
    DayInWeek(
      "J",
    ),
    DayInWeek(
      "V",
    ),
    DayInWeek(
      "S",
    ),
    DayInWeek(
      "D",
    ),
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      backgroundColor: const Color(0xffF2F2F2),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(60.0),
          decoration: const BoxDecoration(
            color: Color(0xffF2F2F2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyInputfiled (title: "Start Time",
           hint: _startTime.toString() ,
           widget: IconButton(icon: const Icon(Icons.access_time_rounded , color: Colors.grey,) , onPressed: (){
 _getTimeFromUser(isStartTime: true);
           },),)
           
           ,
           
        
              MyInputfiled (title: "End Time",
           hint: _endTime.toString() ,
           widget: IconButton(icon: const Icon(Icons.access_time_rounded , color: Colors.grey,) , onPressed: (){
             _getTimeFromUser(isStartTime: false);
           },),),
           SizedBox(
            height: 20,
           ),
           Text(
            "Days" , 
            style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold),
            
           ),
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectWeekDays(
            border: false,
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [const Color(0xFFE55CE4), const Color(0xFFBB75FB)],
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            onSelect: (values) { // <== Callback to handle the selected days
                print(values);
            }, days: _days,
          ),
        ),
            ]
          ),
        ),
      ),
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
   var pickerTime = await  _showTimePicker();
   String _formatedTime = pickerTime.format(context);
   if(pickerTime == null){

   }else if (isStartTime == true){
     setState((){_startTime = pickerTime ;});
   }else if(isStartTime == false){
     setState((){_endTime= pickerTime;});
   }
  }

  _showTimePicker(){
    return showTimePicker(initialEntryMode: TimePickerEntryMode.dial, context: context, initialTime: TimeOfDay.now());
  }
}
