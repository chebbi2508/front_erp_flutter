import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pfe/models/planning.dart';
import 'package:pfe/screens/pointage/add_pointing_super.dart';
import 'package:pfe/screens/pointage/updatePonting.dart';
import 'package:pfe/services/api.dart';
import 'package:pfe/theme/colors.dart';
import 'package:pfe/theme/theme.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:textfield_search/textfield_search.dart';
import '../../accueil/acceuil_user.dart';
import '../../navDrawer.dart';
import 'add_pointing.dart';
import '../../button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../input_filed.dart';
import '../../models/activite.dart';
import '../../models/user.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../services/callapi.dart';
import 'add_pointing_user.dart';

class PointageView extends StatefulWidget {
  const PointageView({Key? key}) : super(key: key);

  @override
  State<PointageView> createState() => _PointageViewState();
}

class _PointageViewState extends State<PointageView> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay _endTime = TimeOfDay.now();
  TimeOfDay _startTime = TimeOfDay.now();

  TextEditingController user = TextEditingController();
  TextEditingController activity = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  //getuser info
  var userData;
  String fullName = '';
  int userId = 0;
  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  //getusers
  List lesuser = [];
  List nomusers = [];
  getusers() async {
    // String myUrl = "http://10.0.2.2:8000/api/getusers";
    http.Response response = await CallApi().getData('getusers');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      lesuser = ll.map<User>((json) => User.fromJson(json)).toList();
      if (userData == 'admin') {
        lesuser =
            lesuser.where((lesuser) => lesuser.created_by == userId).toList();
      } else {
        lesuser = ll.map<User>((json) => User.fromJson(json)).toList();
      }
      if(this.mounted)
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
    // String myUrl = "http://10.0.2.2:8000/api/getactivites";
    http.Response response = await CallApi().getData('getactivites');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      activites = ll.map<Activite>((json) => Activite.fromJson(json)).toList();
      if(this.mounted)
      setState(() {
        nomactivite = activites.map((activites) => activites.name).toList();
      });
      nomactivite = activites.map((activites) => activites.name).toList();
    }
    print(nomactivite);
    return nomactivite;
  }

  //getplannings
  List<Planning> tousplannings = [];
  getplannings() async {
    // String myUrl = "http://10.0.2.2:8000/api/getplannings";
    http.Response response = await CallApi().getData('getpointings');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      tousplannings =
          ll.map<Planning>((json) => Planning.fromJson(json)).toList();
      setState(() {
        if (userData == 'user') {
          tousplannings = tousplannings
              .where((tousplannings) => tousplannings.user_id == userId)
              .toList();
        } else {
          tousplannings =
              ll.map<Planning>((json) => Planning.fromJson(json)).toList();
        }
      });
    }
    print(tousplannings);
    return tousplannings;
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((_perf) {
      userData = _perf.getString("type");
      fullName = _perf.getString("fullName")!;
      userId = _perf.getInt("userId")!;
      getusers().then(
        (lesuser) {
          setState(() {
            lesuser;
            nomusers;
          });
        },
      );
    });

    getactivites().then((activites) {
      if(this.mounted)
      setState(() {
        activites;
        nomactivite;
      });
    });

    getplannings().then((tousplannings) {
      setState(() {
        tousplannings;
      });
    });

    //    _getUserInfo();
  }

  final CalendarController _controller = CalendarController();
  int size = 40;
  TextEditingController _user = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (userData == 'admin' || userData == 'superadmin') {
      return Scaffold(
        appBar:   AppBar(
               title: Row(
                children: [
                  Text(
                    fullName,
                     
                  ),
                ],
              ),
           
            ) ,
             drawer:  NavDrawer(context),
        floatingActionButton: FloatingActionButton(backgroundColor: kPrimaryColor,
          child: Icon(Icons.add),
          elevation: 8,
          onPressed: (() {
            if (userData == 'admin') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddTaskPointingPage(),
                  ));
            } else if (userData == 'superadmin') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddPointingSuperPage(),
                  ));
            }
          }),
        ),
        body: Column(
          children: <Widget>[
            //      Row(children: [

            //       Expanded (child: DropDownField(
            //                                   //controller: ligneselected,
            //                                   hintText: "Select User",
            //                                   enabled: true,
            //                                   //value: ,
            //                                   items: nomusers.cast<String>(),
            //                                   onValueChanged: (value) {
            //                                     setState(() {
            //                                       print(value);
            //                                     String  name = value ;
            //                                      late int user_id ;
            //                                       for(int i =0 ; i< lesuser.length ; i++){
            //                                        List iduser = lesuser
            //     .where((lesuser) =>
            //         lesuser.firstname == name.split(' ')[0] && lesuser.lastname == name.split(' ')[1])
            //     .toList();
            // user_id = iduser[0].id;
            //                                       }
            //                                      Navigator.push(
            //        context,
            //        MaterialPageRoute(
            //          builder: (BuildContext context) =>  ResourceView(user_id),
            //        ));
            //                                     });
            //                                   },
            //                                 ),),
            //     ],),

            Expanded(
              flex: 2,
              child: SfCalendar(
                view: CalendarView.month,
                allowedViews: const [
                  CalendarView.month,
                  CalendarView.week,
                  CalendarView.day,
                ],
                showDatePickerButton: true,
                controller: _controller,
                dataSource: getCalendarDataSource(),
                //   onTap: (CalendarTapDetails details) {
                //   if(details.appointments!.isNotEmpty){
                //   alerte(details.appointments![0].id,details.appointments![0].subject);
                //   }
                // },   
                   onLongPress:  (CalendarLongPressDetails details){
                 if(details.appointments!.isNotEmpty){
                  alerte(details.appointments![0].id,details.appointments![0].subject);
                  }
                }, 
                monthViewSettings: MonthViewSettings(
                    showAgenda: true,
                    agendaViewHeight: MediaQuery.of(context).size.height / 5),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar:   AppBar(
               title: Row(
                children: [
                  Text(
                    fullName,
                    ),
                ],
              ),
          
             ),
           drawer:  NavDrawer(context),
        floatingActionButton: FloatingActionButton(backgroundColor: kPrimaryColor,
          child: Icon(Icons.add),
          elevation: 8,
          onPressed: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AddPointingUserPage(),
                ));
          }),
        ),
        body: Column(
          children: <Widget>[
            FlatButton(
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ResourceUserView(),
                      ));
                }),
                child: Text('TimeLine')),
            Expanded(
              child: SfCalendar(
                view: CalendarView.month,
                allowedViews: const [
                  CalendarView.month,
                  CalendarView.week,
                  CalendarView.day,
                ],
                controller: _controller,
                dataSource: getCalendarDataSource(),
                monthViewSettings: MonthViewSettings(
                    showAgenda: true,
                    agendaViewHeight: MediaQuery.of(context).size.height / 5),
              ),
            ),
          ],
        ),
      );
    }
  }

  _adddatebar() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: DatePicker(
          DateTime.utc(2021),
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

  alerte(int _id, name) async {
   showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              title: Column(children: [Text('User : $name')]),
              content: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: (() => delete(_id)),
                  child: Row(children: [
                    Icon(
                      Icons.cancel,
                      size: 16.0,
                    ),
                    Text(' Delete')
                  ]),
                ),
                SizedBox(width: 5.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kSeconderyColor, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: (() {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => UpdateTaskPointingPage(id: _id,),
                  ));
                    // onbutton(_id);
                  }),
                  child: Row(children: [
                    Icon(
                      Icons.edit,
                      size: 16.0,
                    ),
                    Text(' Update')
                  ]),
                ),
              ]));
        });

  }

  Future<void> onbutton(int _id ) async {
   http.Response response = await CallApi().getData('getpointings/$_id');
    var json = jsonDecode(response.body);
    var editPointing = Planning.fromJson(json);
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
                  "Update Poniting",
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
                                initialList: nomusers,
                                controller: user,
                                label: 'User',
                              ),
                            ),
                          ])),
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
                          label: "Update Pointing",
                          ontap: () => {update(_id, editPointing)}),
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
     //String myUrl = "http://10.0.2.2:8000/api/deleteplanning/$id";
    http.Response response = await CallApi().deleteData('deletepointing/$id');
    Map responseMap = jsonDecode(response.body);
    print(responseMap);
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => PointageView(),
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
    String _formatedTime = pickerTime.format(context);
    if (pickerTime == null) {
    } else if (isStartTime == true) {
      setState(() {
        _startTime = pickerTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = pickerTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.dial,
        context: context,
        initialTime: TimeOfDay.now());
  }

  void update(int _id, Planning plannings) async {
    print(_id);
    print(plannings);

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
      "activity": activite_id,
      "employe": plannings.user_id,
      'duration': duration.split('.')[0],
      'status': plannings.status,
      'note': note.text,
      'user_id': plannings.user_id,
      'version_id': 1,
    };
    print(data);
    http.Response res = await CallApi().putData(data, 'updatepointing/$_id');
    var body = json.decode(res.body);
    print(body);
    if (body['message'] == 'pointing updated.') {
      errorSnackBar(context, body['message']);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => PointageView(),
          ));
    }
  }

  Color currentColor = Color.fromARGB(255, 230, 217, 236);

  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    for (int i = 0; i < tousplannings.length; i++) {
      late String aactt = '';
      late String name;

      for (int j = 0; j < activites.length; j++) {
        List idactivites = activites
            .where((activites) => activites.id == tousplannings[i].activity)
            .toList();
        aactt = idactivites[0].name;
        currentColor = Color(idactivites[0].color);
      }

      for (int k = 0; k < activites.length; k++) {
        List idnames = lesuser
            .where((element) => element.id == tousplannings[i].user_id)
            .toList();
        name = idnames.length != 0
            ? idnames[0].firstname + ' ' + idnames[0].lastname
            : '';
      }
      appointments.add(Appointment(
        startTime: tousplannings[i].start_time,
        endTime: tousplannings[i].end_time,
        subject: aactt + '--' + name != null ? name : "",
        color: currentColor,
        id:tousplannings[i].id
      ));
    }
    print(appointments);
    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
