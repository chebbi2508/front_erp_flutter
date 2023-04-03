import 'dart:convert';
import 'dart:math';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:pfe/screens/planning/planning.dart';
import 'package:pfe/services/callapi.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../models/activite.dart';
import '../../models/user.dart';
import '../../theme/colors.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _endTime = DateTime.now();
  DateTime _startTime = DateTime.now();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController endCtl = TextEditingController();
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay timeEnd = TimeOfDay.now();
  TextEditingController startDateText = new TextEditingController();
  TextEditingController endDateText = new TextEditingController();
  //getusers
  List lesuser = [];
  List nomusers = [];
  var _selectedUser;
  var _selectedActivity;

  getusers() async {
    String myUrl = "http://10.0.2.2:8000/api/getusers";
    http.Response response = await http.get(Uri.parse(myUrl));
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      lesuser = ll.map<User>((json) => User.fromJson(json)).toList();
      lesuser =
          lesuser.where((lesuser) => lesuser.created_by == userId).toList();
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
  int userId = 0;
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
  // var userData;
  // void _getUserInfo() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var userJson = localStorage.getString('user');
  //   var user = json.decode(userJson!);
  //   setState(() {
  //     userData = user;
  //   });
  // }
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((_perf) {
      userId = _perf.getInt("userId")!;
    });
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
    //_getUserInfo();
  }

  TextEditingController user = TextEditingController();
  TextEditingController activity = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _form,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),

                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0),
                //   child: DropDownField(
                //   //controller: ligneselected,
                //   hintText: "Job",
                //   enabled: true,
                //   controller: widget.job.isEmpty
                //       ? TextEditingController()
                //       : TextEditingController(text: widget.job),
                //   items: widget.jobs.cast<String>(),
                //   onValueChanged: (value) {
                //     widget.job = value;
                //   },
                // ),
                // ),
                //  Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0),
                //   child:DropDownField(
                //   //controller: ligneselected,
                //   hintText: "Population",
                //   enabled: true,
                //   controller: widget.population.isEmpty
                //       ? TextEditingController()
                //       : TextEditingController(text: widget.population),
                //   items: widget.populations.cast<String>(),
                //   onValueChanged: (value) {
                //     widget.population = value;
                //   },
                // ),
                // ),
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
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    validator: (value) =>
                        value == null ? 'choose equipment' : null,
                    hint: Text("User *"),
                    items: nomusers.map((dynamic item) {
                      return new DropdownMenuItem<String>(
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
                        user.text = val! ;
                        _selectedUser = val;
                      });
                    },
                    value: _selectedUser,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: DateTimePicker(
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
                  child: DateTimePicker(
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
                        return 'Please enter end date';
                      }
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                ),
                // Padding(
                //     padding: const EdgeInsets.only(bottom: 20.0),
                //     child: TextFormField(
                //       controller: timeCtl, // add this line.
                //       decoration: InputDecoration(
                //         labelText: 'Start time*',
                //       ),
                //       onTap: () async {
                //         FocusScope.of(context).requestFocus(new FocusNode());

                //         TimeOfDay? picked = await showTimePicker(
                //             context: context, initialTime: time);
                //         if (picked != null && picked != time) {
                //           timeCtl.text = picked.toString(); // add this line.
                //           setState(() {
                //             time = picked;
                //           });
                //         }
                //       },
                //     )),
                // Padding(
                //     padding: const EdgeInsets.only(bottom: 20.0),
                //     child: TextFormField(
                //       controller: endCtl, // add this line.
                //       decoration: InputDecoration(
                //         labelText: 'End time*',
                //       ),
                //       onTap: () async {
                //         FocusScope.of(context).requestFocus(new FocusNode());

                //         TimeOfDay? picked = await showTimePicker(
                //             context: context, initialTime: timeEnd);
                //         if (picked != null && picked != timeEnd) {
                //           endCtl.text = picked.toString(); // add this line.
                //           setState(() {
                //             timeEnd = picked;
                //           });
                //         }
                //       },
                //     )),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: note,
                    cursorColor: Color(0xFF0D47A1),
                    style: TextStyle(color: Color(0xFF0D47A1)),
                    decoration: InputDecoration(
                      labelText: 'Note',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.note,
                        color: Colors.grey[800],
                        size: 22,
                      ),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1.0)),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0),
                //   child: DropdownButton<String>(
                //     items: ['active' , 'Bloqué'].map((String value) {
                //       return DropdownMenuItem<String>(
                //         value:  _selectedStatus,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //     onChanged: (value) {
                //        setState(() {
                //        _selectedStatus = value!;
                //       });
                //     },
                //   )),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0),
                //   child:DropDownField(
                //   //controller: ligneselected,
                //   hintText: "Status",
                //   enabled: true,
                //   controller: widget.status.isEmpty
                //       ? TextEditingController()
                //       : TextEditingController(text: widget.status),
                //   items: widget.statu.cast<String>(),
                //   onValueChanged: (value) {
                //     widget.status = value;
                //   },
                // ),
                // ),

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                       await createtask(userId);
                      },
                      color: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        'Create Task',
                        style: TextStyle(
                            fontSize: 14,
                            // letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(),
    //   body: Container(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //             Text(
    //               "Add Taskdfdf",
    //               style: heading,
    //             ),
    //             const SizedBox(height: 10,),
    //                 Text(
    //                   "User",
    //                   style: titleStyle,
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(left: 10),
    //                   child: DropDownField(
    //                     //controller: ligneselected,
    //                     hintText: "Article",
    //                     enabled: true,
    //                     controller: user,
    //                     items: nomusers.cast<String>(),
    //                     onValueChanged: (value) {
    //                       user.text = value;
    //                     },
    //                   ),
    //                 ),

    //                 Text(
    //                   "Activity",
    //                   style: titleStyle,
    //                 ),
    //                 Expanded(
    //                   child: DropDownField(
    //                     //controller: ligneselected,
    //                     hintText: "Article",
    //                     enabled: true,
    //                     controller: activity,
    //                     items: nomactivite.cast<String>(),
    //                     onValueChanged: (value) {
    //                       activity.text = value;
    //                     },
    //                   ),
    //                 ),

    //             // Container(
    //             //   margin: EdgeInsets.only(top: 10),
    //             //   child: Column(
    //             //     crossAxisAlignment: CrossAxisAlignment.start,
    //             //     children: [],
    //             //   ),
    //             // ),
    //             //  MyInputfiled(title: "Date", hint: DateFormat.yMd().format(_selectedDate) ,
    //             //    widget: IconButton(
    //             //      icon: const Icon(Icons.calendar_today_outlined ,
    //             //      color: Colors.grey,),
    //             //      onPressed: () {
    //             //       _getDateFromUser();
    //             //    },),
    //             //    ) ,
    //             Row(
    //               children: [
    //                 Expanded(
    //                     child: MyInputfiled(
    //                   title: "Start Time",
    //                   hint: _startTime.toString(),
    //                   widget: IconButton(
    //                     icon: const Icon(
    //                       Icons.access_time_rounded,
    //                       color: Colors.grey,
    //                     ),
    //                     onPressed: () {
    //                       _getTimeFromUser(isStartTime: true);
    //                     },
    //                   ),
    //                 )),
    //                 Expanded(
    //                     child: MyInputfiled(
    //                   title: "End Time",
    //                   hint: _endTime.toString(),
    //                   widget: IconButton(
    //                     icon: const Icon(
    //                       Icons.access_time_rounded,
    //                       color: Colors.grey,
    //                     ),
    //                     onPressed: () {
    //                       _getTimeFromUser(isStartTime: false);
    //                     },
    //                   ),
    //                 ))
    //               ],
    //             ),
    //             MyInputtext(
    //               title: "Note",
    //               hint: "Enter your note",
    //               controller: note,
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Container(
    //                   padding: EdgeInsets.only(top: 10, bottom: 5),
    //                   child: MyButton(
    //                       label: "Create Task", ontap: () => {createtask(userId)}),
    //                 )
    //               ],
    //             ),

    //           ],
    //       ),
    //   ),

    // );
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

  createtask(userId) async {
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
          .where((activites) => activites.name == _selectedActivity.toString())
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
      "start_time": startDateText.text.toString(),
      //DateFormat("HH:mm").format(new DateTime(2000, 1, 1, time.hour, time.minute)),
      "end_time": endDateText.text.toString(), 
       //DateFormat("HH:mm").format(new DateTime(2000, 1, 1, timeEnd.hour, timeEnd.minute)),
      "activity": activite_id,
      "employe": user_id,
      'duration': 0,
      'status': 'validé',
      // 'date': date,
      'note': note.text != null ? note.text : "",
      'user_id': userId != null ? '$userId' : '',
      'version_id': 1,
    };

    print(data);
    http.Response res = await CallApi().postData(data, 'postplannings');
    print("res");
    print(res);
    var body = jsonDecode(res.body);

    print(json.encode(body['->status'])); // hethya 9a3da trja3 fi null
    if (body['->status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Success .. !"),
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
