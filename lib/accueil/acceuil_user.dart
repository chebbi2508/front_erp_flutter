import 'dart:convert';
import 'dart:math';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
    as datetime;
import 'package:date_picker_timeline/date_picker_widget.dart' as date;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:textfield_search/textfield_search.dart';

import '../button.dart';
import '../components/drawer.dart';
import '../input_filed.dart';
import '../models/activite.dart';
import '../models/planning.dart';
import '../models/user.dart';
import '../navDrawer.dart';
import '../screens/planning/planning.dart';
import '../services/api.dart';
import '../services/callapi.dart';
import '../theme/theme.dart';
import 'todotime.dart';

class ResourceUserView extends StatefulWidget {
  @override
  ResourceViewState createState() => ResourceViewState();
}

class ResourceViewState extends State<ResourceUserView> {
  DateTime selectedDate = DateTime.now();
  DateTime _endTime = DateTime.now();
  DateTime _startTime = DateTime.now();

  TextEditingController user = TextEditingController();
  TextEditingController activity = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();

  List<Appointment> _shiftCollection = <Appointment>[];
  List<CalendarResource> _employeeCollection = <CalendarResource>[];
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

  List activites = [];
  List nomactivite = [];
  getactivites() async {
    // String myUrl = "http://10.0.2.2:8000/api/getactivites";
    http.Response response = await CallApi().getData('getactivites');
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

  //getplannings
  List tousplannings = [];

  getplannings() async {
    // String myUrl = "http://10.0.2.2:8000/api/getplannings";
    http.Response response = await CallApi().getData('getplannings');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      tousplannings =
          ll.map<Planning>((json) => Planning.fromJson(json)).toList();
      setState(() {
        tousplannings = tousplannings
            .where((tousplannings) => tousplannings.employe == userData['id'])
            .toList();
      });
    }

    print(tousplannings);

    return tousplannings;
  }

  @override
  void initState() {
    _getUserInfo();
    getplannings().then(
      (tousplannings) {
        setState(() {
          tousplannings;
        });
      },
    );

    getactivites().then(
      (activites) {
        setState(() {
          activites;
          nomactivite;
        });
      },
    );

    super.initState();
  }

  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color.fromRGBO(238, 238, 238, 1),
            title: Row(
              children: [
                Text(
                  userData != null ? '${userData['firstname']}' : '',
                  style: TextStyle(
                      color: Color.fromRGBO(1, 60, 77, 30), fontSize: 25),
                ),
              ],
            ),
            iconTheme: const IconThemeData(
              color: Color.fromRGBO(112, 112, 112, 1),
            ),
          )),
      drawer: NavDrawer(context),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Foulen ben foulen ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Ingénieur web',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _adddatebar(),
          SizedBox(
            height: 30,
          ),
          //NOTE : TASK LIST
          Container(
            // padding: EdgeInsets.symmetric(
            //   horizontal: 20,
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task List',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //  START TODOLIST
                _showTasks(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _adddatebar() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: date.DatePicker(
          DateTime.utc(2022),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryclr,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          )),
          dayTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          )),
          monthTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          )),
          onDateChange: (date) {
            setState(() {
              _selectedDate = date;
              print(_selectedDate);
            });
          },
        ));
  }

  Color currentColor = Color.fromARGB(255, 230, 217, 236);

// List<Appointment> getAppointments() {
//   List<Appointment> meetings = <Appointment>[];
//   final DateTime today = DateTime.now();
//   final DateTime startTime =
//       DateTime(today.year, today.month, today.day, 9, 0, 0);
//   final DateTime endTime = startTime.add(const Duration(hours: 2));
//    for (int i = 0 ; i< 2 ; i++ ){
//   meetings.add(Appointment(
//       startTime: startTime,
//       endTime: endTime,
//       subject: 'Board Meeting',
//       color: Colors.blue,
//       recurrenceRule: 'FREQ=DAILY;COUNT=10',
//       //isAllDay: false
//       ));
//    };
//   print(meetings);
//   return meetings;
// }
//  List<TodoList>  getCalendarDataSource() {
//     final List<TodoList> appointments = <TodoList>[];
//     for (int i =0 ; i<tousplannings.length ; i++){
//     appointments.add(TodoList(
//       time: tousplannings[i].start_time,
//                   timeRange: tousplannings[i].start_time + '-' + tousplannings[i].end_time ,
//                   title: tousplannings[i].idactivites,
//                   statusBg: 0,
//                   statusRange: 0,
//                   statusTitle: 0,
//     ));};
//      print(appointments);
//     return appointments;
//   }

  _showTasks() {
    final List<TodoList> appointments = <TodoList>[];
    //String date = "5/22/2022";
    print(DateFormat.yMd().format(_selectedDate));
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: tousplannings.length,
        itemBuilder: (_, index) {
          tousplannings.sort((a, b) {
            //sorting in ascending order
            return DateTime.parse(a.start_time.toString())
                .compareTo(DateTime.parse(b.start_time.toString()));
          });
          print(
              DateFormat('yyyy-MM-dd').format(tousplannings[index].start_time));
          print(DateFormat('yyyy-MM-dd').format(_selectedDate));
          if (DateFormat('yyyy-MM-dd')
                  .format(tousplannings[index].start_time) ==
              DateFormat('yyyy-MM-dd').format(_selectedDate)) {
            String? usss;
            //  for(int i =0 ; i< lesuser.length ; i++ ){
            //     List iduser = lesuser
            //       .where((lesuser) =>
            //           lesuser.id == tousplannings[index].employee)
            //       .toList();
            //   usss = iduser[0].firstname + ' ' + iduser[0].lastname ;
            //  }
            late String aactt;

            for (int i = 0; i < activites.length; i++) {
              List idactivites = activites
                  .where((activites) =>
                      activites.id == tousplannings[index].activity)
                  .toList();
              aactt = idactivites[0].name;
            }
            int _id = tousplannings[index].id;
            //  appointments.add(TodoList(
            //   time: DateFormat('HH:mm').format(tousplannings[index].start_time),
            //               timeRange: tousplannings[index].start_time.toString() + '-' + tousplannings[index].end_time.toString() ,
            //               title: aactt,
            //               statusBg: 0,
            //               statusRange: 0,
            //               statusTitle: 0,
            // ));
            // print(appointments);
            return SingleChildScrollView(
                child: GestureDetector(
                    onTap: (() => alerte(_id, tousplannings[index])),
                    child: TodoList(
                      time: DateFormat('HH:mm')
                          .format(tousplannings[index].start_time),
                      timeRange: tousplannings[index].start_time.toString() +
                          '-' +
                          tousplannings[index].end_time.toString(),
                      title: aactt,
                      statusBg: 0,
                      statusRange: 0,
                      statusTitle: 0,
                      color: currentColor,
                    )));
            //   ListView(    scrollDirection: Axis.vertical,
            // shrinkWrap: true, children: appointments)));
          } else {
            return Container();
          }
        });
  }

  alerte(int _id, Planning plannings) async {
    print(_id);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            title: Column(children: const []),
            content: Row(
              children: [
                Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 0, 0),
                        borderRadius: BorderRadius.circular(30)),
                    child: FlatButton(
                      onPressed: (() => delete(_id)),
                      child: Text("Delete"),
                    )),
                Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 255, 42),
                        borderRadius: BorderRadius.circular(30)),
                    child: FlatButton(
                      onPressed: (() => onbutton(_id, plannings)),
                      child: Text("Update"),
                    ))
              ],
            ),
          );
        });
  }

  void onbutton(int _id, Planning plannings) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Update Task",
                  style: heading,
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
                      Container(
                          height: 52,
                          margin: EdgeInsets.only(top: 8.0),
                          padding: EdgeInsets.only(left: 14),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                // width: 1.0
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            Expanded(
                              child: TextFieldSearch(
                                // value: _customerName,
                                initialList: nomactivite,
                                controller: activity, label: 'Activity',
                              ),
                            ),
                          ])),
                    ],
                  ),
                ),
                MyInputfiled(
                  title: "Date",
                  hint: DateFormat.yMd().format(selectedDate),
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
                          label: "Update Task",
                          ontap: () => {update(_id, plannings)}),
                    )
                  ],
                ),
                Row(
                  children: [],
                )
              ],
            )),
          );
        });
  }

  void delete(int id) async {
    print(id);
    //String myUrl = "http://10.0.2.2:8000/api/deleteplanning/$id";
    http.Response response = await CallApi().deleteData('deleteplanning/$id');
    Map responseMap = jsonDecode(response.body);
    print(responseMap);
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CalendarPage(),
          ));
      errorSnackBar(context, responseMap.toString());
    } else {
      errorSnackBar(context, responseMap.values.first[0]);
    }
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
    return datetime.DatePicker.showDateTimePicker(context,
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

  void update(int _id, Planning plannings) async {
    print(_id);
    print(plannings);

    final String date = DateFormat('yyyy-MM-dd').format(selectedDate);

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

    int employe = userData['id'];

    var data = {
      "start_time": start_time,
      "end_time": end_time,
      "activity": activite_id,
      "employe": employe,
      'duration': duration.split('.')[0],
      'status': 'active',
      'date': date,
      'note': note.text,
      'user_id': userData != null ? '${userData['id']}' : '',
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
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
