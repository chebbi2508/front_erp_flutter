import 'dart:convert';
import 'dart:math';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pfe/button.dart';
import 'package:pfe/input_filed.dart';
import 'package:pfe/screens/planning/planning.dart';
import 'package:pfe/services/callapi.dart';
import 'package:pfe/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:http/http.dart' as http;

import '../../models/activite.dart';
import '../../models/user.dart';

class AddTaskSuperPage extends StatefulWidget {
  const AddTaskSuperPage({Key? key}) : super(key: key);
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskSuperPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _endTime = DateTime.now();
  DateTime _startTime = DateTime.now();

  //getusers
  List lesuser = [];
  List nomusers = [];
  getusers() async {
    String myUrl = "http://10.0.2.2:8000/api/getusers";
    http.Response response = await http.get(Uri.parse(myUrl));
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      lesuser = ll.map<User>((json) => User.fromJson(json)).toList();

      setState(() {
        nomusers = lesuser
            .map((lesuser) => lesuser.firstname + ' ' + lesuser.lastname)
            .toList();
      });
    }

    print(nomusers);
    return nomusers;
  }

  List activites = [];
  List nomactivite = [];
  getactivites() async {
    String myUrl = "http://10.0.2.2:8000/api/getactivites";
    http.Response response = await http.get(Uri.parse(myUrl));
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      activites = ll.map<Activite>((json) => Activite.fromJson(json)).toList();

      setState(() {
        nomactivite = activites.map((activites) => activites.name).toList();
      });

      nomactivite = activites.map((activites) => activites.name).toList();
    }
    print(nomactivite);
    return nomactivite;
  }

  //getuser info
  var userData;
  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  @override
  void initState() {
    super.initState();
    getactivites().then(
      (activites) {
        setState(() {
          activites;
          nomactivite;
        });
      },
    );
    getusers().then(
      (lesuser) {
        setState(() {
          lesuser;
          nomusers;
        });
      },
    );
    _getUserInfo();
  }

  TextEditingController user = TextEditingController();
  TextEditingController activity = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add Task",
              style: heading,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User",
                    style: titleStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: DropDownField(
                      //controller: ligneselected,
                      hintText: "User",
                      enabled: true,
                      controller: user,
                      items: nomusers.cast<String>(),
                      onValueChanged: (value) {
                        user.text = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Activity",
                    style: titleStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: DropDownField(
                      //controller: ligneselected,
                      hintText: "Article",
                      enabled: true,
                      controller: activity,
                      items: nomactivite.cast<String>(),
                      onValueChanged: (value) {
                        activity.text = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            MyInputfiled(
              title: "Date",
              hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _getDateFromUser();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: MyInputfiled(
                  title: "Start Time",
                  hint: _startTime.toString(),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _getTimeFromUser(isStartTime: true);
                    },
                  ),
                )),
                Expanded(
                    child: MyInputfiled(
                  title: "End Time",
                  hint: _endTime.toString(),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _getTimeFromUser(isStartTime: false);
                    },
                  ),
                ))
              ],
            ),
            MyInputtext(
              title: "Note",
              hint: "Enter your note",
              controller: note,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: MyButton(
                      label: "Create Task", ontap: () => {createtask()}),
                )
              ],
            ),
            Row(
              children: [],
            )
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
        theme: DatePickerTheme(
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

  createtask() async {
    final String code = 'co-de' + Random().nextInt(1000).toString();
    final String date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    int? user_id;
    for (int i = 0; i < lesuser.length; i++) {
      List iduser = lesuser
          .where((lesuser) =>
              lesuser.firstname == user.text.split(' ')[0] &&
              lesuser.lastname == user.text.split(' ')[1])
          .toList();
      user_id = iduser[0].id;
    }
    int? activite_id;
    for (int i = 0; i < activites.length; i++) {
      List idactivites = activites
          .where((activites) => activites.name == activity.text)
          .toList();
      activite_id = idactivites[0].id;
    }
    String start_time = "${_startTime.hour}" + ':' + "${_startTime.minute}";
    String end_time = "${_endTime.hour}" + ':' + "${_endTime.minute}";

    var format = DateFormat("HH:mm");
    var start = format.parse(start_time);
    var end = format.parse(end_time);

    String duration = '0';

    var data = {
      "code": code,
      "start_time": _startTime.toString(),
      "end_time": _endTime.toString(),
      "activity": activite_id,
      "employe": user_id,
      'duration': duration.split('.')[0],
      'status': 'validé',
      'note': note.text,
      'user_id': userData != null ? '${userData['id']}' : '',
      'version_id': 1,
    };

    print(data);
    http.Response res = await CallApi().postData(data, 'postplannings');
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
          builder: (context) => CalendarPage(),
        ),
      );
    }
  }
}
