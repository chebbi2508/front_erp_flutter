import 'dart:convert';
import 'dart:math';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pfe/button.dart';
import 'package:pfe/input_filed.dart';
import 'package:pfe/screens/pointage/pointage.dart';
import 'package:pfe/services/callapi.dart';
import 'package:pfe/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:http/http.dart' as http;

import '../../models/activite.dart';
import '../../models/user.dart';

class AddPointingUserPage extends StatefulWidget {
  const AddPointingUserPage({
    Key? key,
  }) : super(key: key);
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddPointingUserPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _endTime = DateTime.now();
  DateTime _startTime = DateTime.now();
  int userId = 0;
  List activites = [];
  List nomactivite = [];
  DateTime _selected = DateTime.now();
  TextEditingController startDateText = new TextEditingController();
    TextEditingController endDateText = new TextEditingController();

  
  TextEditingController timeCtl = TextEditingController();
  TextEditingController endCtl = TextEditingController();

  GlobalKey<FormState> _form = GlobalKey<FormState>();
  var _selectedActivity;
  getactivites() async {
    String myUrl = "http://10.0.2.2:8000/api/getactivites";
    http.Response response = await http.get(Uri.parse(myUrl));
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      activites = ll.map<Activite>((json) => Activite.fromJson(json)).toList();
if (this.mounted){
      setState(() {
        nomactivite = activites.map((activites) => activites.name).toList();
      });
    }
      nomactivite = activites.map((activites) => activites.name).toList();
    }
    print(nomactivite);
    return nomactivite;
  }

  //getuser info
  //var userData;
  // void _getUserInfo() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var userJson = localStorage.getString('user');
  //   var user = json.decode(userJson!);
  //   setState(() {
  //     userData = user;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((_perf) {
      userId = _perf.getInt("userId")!;
    });
    getactivites().then(
      (activites) {
        if(this.mounted)
        setState(() {
          activites;
          nomactivite;
        });
      },
    );
  }

  TextEditingController user = TextEditingController();
  TextEditingController activity = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  @override
  Widget build(BuildContext context) {
    TimeOfDay timeEnd = TimeOfDay.now();
    TimeOfDay time = TimeOfDay.now();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Pointing"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: DropdownButtonFormField<dynamic>(
                    isExpanded: true,
                    validator: (value) =>
                        value == null ? 'choose Activity' : null,
                    hint: Text("Activity *"),
                    items: nomactivite.map((dynamic item) {
                      return new DropdownMenuItem<dynamic>(
                          child: Text(
                            item, //Names that the api dropdown contains
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          value: item //id projects
                          );
                    }).toList(),
                    onChanged: (var val) {
                      setState(() {
                        _selectedActivity = val;
                      });
                    },
                    value: _selectedActivity,
                  ),
                ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                    child:  DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                controller: startDateText,
                dateMask: 'd MMM, yyyy',
                initialValue: null,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                icon: Icon(Icons.date_range),
                dateLabelText: 'Start date *',
                timeLabelText: "Hour",
                onChanged: (val) {
                  startDateText.text = val;
                 },
                validator: (value) {
                  if (value == null) {
                 
                    return 'Please enter Start date';
                  }
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ),
               Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                    child:  DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                controller: endDateText,
                dateMask: 'd MMM, yyyy',
                initialValue: null,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                icon: Icon(Icons.date_range),
                dateLabelText: 'End date *',
                timeLabelText: "Hour",
                onChanged: (val) {
                  endDateText.text = val;
                 },
                validator: (value) {
                  if (value == null) {
                 
                    return 'Please enter End date';
                  }
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    key: new Key('Note'),
                    decoration: InputDecoration(
                      labelText: 'Note',
                      labelStyle: TextStyle(
                        fontSize: 17,
                        // Tweak this 1,2 moves label bottom-> -1,-2 moves label upwards
                        fontWeight: FontWeight.w500,
                      ),
                      suffixIcon: Icon(
                        Icons.person,
                        size: 18,
                      ),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF0D47A1), width: 1.0)),
                    ),
                    controller: note,
                  ),
                ),

                // MyInputtext(
                //   title: "Note",
                //   hint: "Enter your note",
                //   controller: note,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: FlatButton(
                        color: Colors.green,
                        child: const Text('Create Pointing',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                        await  createtask(time, timeEnd);
                         //Navigator.of(context).pop("yes");
                        },
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2055));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
      print(_selectedDate);
    } else {
      print("iiiii");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickerTime = await _showTimePicker();

    if (pickerTime == null) {
    } else if (isStartTime == true) {
      setState(() {
        _startTime = pickerTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = pickerTime;
        print(_endTime);
      });
    }
  }

  _showTimePicker() {
    return DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2022, 1, 1),
        maxTime: DateTime(2055, 12, 31),
        theme: const DatePickerTheme(
            headerColor: Colors.grey,
            backgroundColor: Colors.white,
            itemStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (date) {
      _startTime = date;
      print(_startTime);
    }, currentTime: DateTime.now(), locale: LocaleType.fr);
  }

  createtask(time, endTime) async {
    final String code = 'co-de' + Random().nextInt(1000).toString();
    final String date = DateFormat('yyyy-MM-dd').format(_selectedDate);

    int? activite_id;
    for (int i = 0; i < activites.length; i++) {
      List idactivites = activites
          .where((activites) => activites.name == _selectedActivity)
          .toList();
      activite_id = idactivites[0].id;
    }
    String start_time = "${time.hour}" + ':' + "${time.minute}";
    String end_time = "${endTime.hour}" + ':' + "${endTime.minute}";

    var format = DateFormat("HH:mm");
    var start = format.parse(start_time);
    var end = format.parse(end_time);

    String? duration;
    if (start.isAfter(end)) {
      print('start is big');
      print('difference = ${start.difference(end)}');
      duration = " ${start.difference(end)}";
    } else if (start.isBefore(end)) {
      print('end is big');
      print('difference = ${end.difference(start)}');
      duration = " ${end.difference(start)}";
    } else {
      print('difference = ${end.difference(start)}');
      duration = " ${end.difference(start)}";
    }

    var data = {
      "code": code,
      "start_time":  startDateText.text.toString(),// _startTime.toString(),
      "end_time":   endDateText.text.toString()  , //_endTime.toString(),
      "activity": activite_id,
      "employe": userId,
      'duration': 0,
      'status': 'approuvé',
      'note': note.text,
      'user_id': userId != null ?  userId  : '',
      'version_id': 1,
    };
    print(data);
    http.Response res = await CallApi().postData(data, 'postpointings');
    var body = jsonDecode(res.body);

    print(json.encode(body['->status']));
    if (body['->status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Success .. !"),
        duration: Duration(seconds: 2),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PointageView(),
        ),
      );
    }
  }
}
