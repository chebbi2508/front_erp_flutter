import 'dart:convert';
 import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:pfe/screens/planning/planning.dart';
import 'package:pfe/services/callapi.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
 import '../../models/activite.dart';
import '../../models/planning.dart';
import '../../models/user.dart';
import '../../services/api.dart';
import '../../theme/colors.dart';

class UpdateTaskPage extends StatefulWidget {
  final id;
  const UpdateTaskPage({Key? key, this.id}) : super(key: key);
  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
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
  var plannigEdit ;
  var  editAct;
  getPlannigData() async {
    DateTime _endTimeEdit = DateTime.now();
    DateTime _startTimeEdit = DateTime.now();
    http.Response response = await CallApi().getData('getplannings/${widget.id}');
    var json = jsonDecode(response.body);
     return Planning.fromJson(json);
  
  }

  void update(int _id, Planning plannings) async {
    print(_id);
    print(plannings);
    String start_time = "${_startTime.hour}" + ':' + "${_startTime.minute}";
    String end_time = "${_endTime.hour}" + ':' + "${_endTime.minute}";

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
      "start_time": start_time,
      "end_time": end_time,
      "activity": plannings.activity,
      "employe": plannings.user_id,
      'duration': duration.split('.')[0],
      'status': plannings.status,
      'note': plannings.note,
      'user_id': plannings.user_id,
      'version_id': 1,
    };
    print(data);
    http.Response res = await CallApi().putData(data, 'updateplanning/$_id');
    var body = json.decode(res.body);
    print(body);
    if (body['message'] == 'planning updated.') {
      errorSnackBar(context, body['message']);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CalendarPage(),
          ));
    }
  }

 
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
             editAct =  activites.toList();
 });

      nomactivite = activites.map((activites) => activites.name).toList();
    }
    print(nomactivite);
    return nomactivite;
  }

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
           editAct;
        });
      },
    );

    getusers().then(
      (lesuser) {
        setState(() {
          lesuser;
          nomusers;
 
        });
            getPlannigData().then(
      (value) {
        setState(() {
          plannigEdit = value ;
      note = TextEditingController(text: plannigEdit.note);
    // _startTimeEdit = plannigEdit.start_time;
    // _endTimeEdit = plannigEdit.end_time;
    startDateText = TextEditingController(text:plannigEdit.start_time.toString());
    endDateText = TextEditingController(text:plannigEdit.end_time.toString());
    _selectedActivity = editAct.where((act) => act.id == plannigEdit.activity).first.name;
    if(lesuser.length !=0){
    _selectedUser = lesuser.where((element) => element.id == plannigEdit.employee).map((lesuser) => lesuser.firstname + ' ' + lesuser.lastname).first;       

    }
     });
      },
    );
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
        title: Text('Update Task'),
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
                        user.text = val!;
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
                
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                      update(widget.id, plannigEdit);
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
  }
 }

//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         builder: (context) {
//           return Container(
//             padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
//             child: SingleChildScrollView(
//                 child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Update Task",
//                   style: heading,
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "User",
//                         style: titleStyle,
//                       ),
//                       Container(
//                           height: 52,
//                           margin: EdgeInsets.only(top: 8.0),
//                           padding: EdgeInsets.only(left: 14),
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey,
//                                 // width: 1.0
//                               ),
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Row(children: [
//                             Expanded(
//                               child: TextFieldSearch(
//                                 initialList: nomusers,
//                                 controller: user,
//                                 label: 'User',
//                               ),
//                             )
//                           ])),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Activity",
//                         style: titleStyle,
//                       ),
//                       Container(
//                           height: 52,
//                           margin: EdgeInsets.only(top: 8.0),
//                           padding: EdgeInsets.only(left: 14),
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey,
//                               ),
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Row(children: [
//                             Expanded(
//                               child: TextFieldSearch(
//                                 // value: _customerName,
//                                 initialList: nomactivite,
//                                 controller: activity, label: 'Activity',
//                               ),
//                             ),
//                           ])),
//                     ],
//                   ),
//                 ),
//                 MyInputfiled(
//                   title: "Date",
//                   hint: DateFormat.yMd().format(selectedDate),
//                   widget: IconButton(
//                     icon: const Icon(
//                       Icons.calendar_today_outlined,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       _getDateFromUser();
//                     },
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: MyInputfiled(
//                       title: "Start Time",
//                       hint: _startTimeEdit.toString(),
//                       widget: IconButton(
//                         icon: const Icon(
//                           Icons.access_time_rounded,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           _getTimeFromUser(isStartTime: true);
//                         },
//                       ),
//                     )),
//                     Expanded(
//                         child: MyInputfiled(
//                       title: "End Time",
//                       hint: _endTimeEdit.toString(),
//                       widget: IconButton(
//                         icon: const Icon(
//                           Icons.access_time_rounded,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           _getTimeFromUser(isStartTime: false);
//                         },
//                       ),
//                     ))
//                   ],
//                 ),
//                 MyInputtext(
//                   title: "Note",
//                   hint: "Enter your note",
//                   controller: note,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.only(top: 10, bottom: 5),
//                       child: MyButton(
//                           label: "Update Task",
//                           ontap: () {
//                             update(_id, plannigEdit);
//                           }),
//                     )
//                   ],
//                 ),
//               ],
//             )),
//           );
//         });