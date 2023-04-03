import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
  import 'package:pfe/theme/colors.dart';
 import '../../models/plageHoraire.dart';
import '../../models/population.dart';
import '../../navDrawer.dart';
import '../../services/callapi.dart';
import 'package:day_picker/day_picker.dart';

class PopulationScreen extends StatefulWidget {
  const PopulationScreen({Key? key}) : super(key: key);

  @override
  State<PopulationScreen> createState() => _PopulationScreenState();
}

class _PopulationScreenState extends State<PopulationScreen> {
  TimeOfDay _endTime = TimeOfDay.now();
  List<String> ldays = [];
  String startDate = '';
  String endDate = '';
  bool _checked1 = false;
  bool _checked2 = false;
  bool _checked3 = false;
  bool _checked4 = false;
  bool _checked5 = false;
  bool _checked6 = false;
  var data;

  List<String> selectDays = [];
  TimeOfDay _startTime = TimeOfDay.now();
  // ignore: prefer_final_fields
  List<DayInWeek> _days = [
    DayInWeek(
      "L",
    ),
    DayInWeek(
      "Ma",
    ),
    DayInWeek(
      "Me",
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
  bool _checked = false;
  TextEditingController timeCtl = TextEditingController();
  TextEditingController endCtl = TextEditingController();

  List populations = [];
  var plageHoraire;

  getpopulation() async {
    http.Response response = await CallApi().getData('getpopulations');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      setState(() {
        populations =
            ll.map<Population>((json) => Population.fromJson(json)).toList();
      });
    }
    return populations;
  }

  Future getPlageHoraire(id) async {
    http.Response response =
        await CallApi().getData('getdatafrompopulation/$id');
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      setState(() {
        data = PlageHoraireModel.fromJson(resBody);
      });
      return data;
    } else {
      return false;
    }
  }

  TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    getpopulation().then(
      (populations) {
        setState(() {
          populations;
        });
      },
    );
  }

  TextEditingController startDateText = new TextEditingController();
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
          ),
        ),
        floatingActionButton: Container(
            child: FloatingActionButton(
          backgroundColor: kSeconderyColor,
          foregroundColor: Colors.white,
          heroTag: 'installed',
          onPressed: () async {
            _showAlertDialogAdd(context);
            // final result = await showModalBottomSheet(
            //     context: context,
            //     builder: (context) {
            //       return Container(
            //           padding: const EdgeInsets.all(20.0),
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(20.0),
            //               topRight: Radius.circular(20.0),
            //             ),
            //           ),
            //           child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 MyInputtext(
            //                   title: "Population Name",
            //                   hint: "Population name",
            //                   controller: name,
            //                 ),
            //                 MyInputfiled(
            //                   title: "Date Début",
            //                   hint: DateFormat.yMd().format(_selectedDate),
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
            //                 RoundedButton(
            //                   color: Colors.green,
            //                   onPressed: () async {
            //                     createpopulation();
            //                   },
            //                   title: 'Add Population',
            //                 ),
            //               ]));
            //     });
          },
          child: const Icon(
            Icons.add,
            size: 25.0,
          ),
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        appBar: AppBar(
          title: const Text("Populations"),
        ),
        drawer: NavDrawer(context),
        body: Container(
            child: Scrollbar(
          thickness: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: populations == null ? 0 : populations.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 4.0),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 0.1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      populations[index].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black87),
                                    ),
                                  ),
                                  PopupMenuButton(
                                      elevation: 3.2,
                                      itemBuilder: (context) => [
                                            PopupMenuItem<int>(
                                                value: 1,
                                                child: Row(
                                                  children: const <Widget>[
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    Text(' Delete'),
                                                  ],
                                                )),
                                            PopupMenuItem<int>(
                                                value: 2,
                                                child: Row(
                                                  children: const <Widget>[
                                                    Icon(
                                                      Icons.edit,
                                                      color: Colors.blue,
                                                    ),
                                                    Text(' Edit'),
                                                  ],
                                                )),
                                            PopupMenuItem<int>(
                                                value: 3,
                                                child: Row(
                                                  children: const <Widget>[
                                                    Icon(Icons.hourglass_bottom,
                                                        color: Colors.black),
                                                    Text(' Plage horaire'),
                                                  ],
                                                )),
                                          ],
                                      onSelected: (result) async {
                                        if (result == 1) {
                                          delete((populations[index].id));
                                        } else if (result == 2) {
                                          updatevue(
                                              context,
                                              populations[index].id,
                                              populations[index].name, populations[index].created_at);
                                        } else {
                                          showPlageHoraire(
                                              context, populations[index].id);
                                          //   showModalBottomSheet<void>(
                                          //       isScrollControlled: true,
                                          //       context: context,
                                          //       builder: (context) {
                                          //         return StatefulBuilder(
                                          //             // this is new
                                          //             builder: (BuildContext
                                          //                     context,
                                          //                 StateSetter setState) {
                                          //           return Container(
                                          //               padding:
                                          //                   const EdgeInsets.all(
                                          //                       20.0),
                                          //               decoration:
                                          //                   const BoxDecoration(
                                          //                 color: Colors.white,
                                          //                 borderRadius:
                                          //                     BorderRadius.only(
                                          //                   topLeft:
                                          //                       Radius.circular(
                                          //                           20.0),
                                          //                   topRight:
                                          //                       Radius.circular(
                                          //                           20.0),
                                          //                 ),
                                          //               ),
                                          //               child:
                                          //                   SingleChildScrollView(
                                          //                 child: Column(
                                          //                     mainAxisAlignment:
                                          //                         MainAxisAlignment
                                          //                             .center,
                                          //                     children: [
                                          //                       MyInputfiled(
                                          //                         initailValue:
                                          //                             startDate,
                                          //                         title:
                                          //                             "Start Time",
                                          //                         hint: _startTime
                                          //                             .toString(),
                                          //                         widget:
                                          //                             IconButton(
                                          //                           icon:
                                          //                               const Icon(
                                          //                             Icons
                                          //                                 .access_time_rounded,
                                          //                             color: Colors
                                          //                                 .grey,
                                          //                           ),
                                          //                           onPressed: () {
                                          //                             _getTimeFromUser(
                                          //                                 isStartTime:
                                          //                                     true);
                                          //                           },
                                          //                         ),
                                          //                       ),
                                          //                       MyInputfiled(
                                          //                         initailValue:
                                          //                             endDate,
                                          //                         title: "End Time",
                                          //                         hint: _endTime
                                          //                             .toString(),
                                          //                         widget:
                                          //                             IconButton(
                                          //                           icon:
                                          //                               const Icon(
                                          //                             Icons
                                          //                                 .access_time_rounded,
                                          //                             color: Colors
                                          //                                 .grey,
                                          //                           ),
                                          //                           onPressed: () {
                                          //                             _getTimeFromUser(
                                          //                                 isStartTime:
                                          //                                     false);
                                          //                           },
                                          //                         ),
                                          //                       ),
                                          //                       const SizedBox(
                                          //                         height: 8,
                                          //                       ),
                                          //                       //  const Text(
                                          //                       //     "Days",
                                          //                       //     textAlign:
                                          //                       //         TextAlign
                                          //                       //             .start,
                                          //                       //     style: TextStyle(
                                          //                       //         fontSize: 18,
                                          //                       //         fontWeight:
                                          //                       //             FontWeight
                                          //                       //                 .bold),
                                          //                       //   ),
                                          //                       // Padding(
                                          //                       //   padding:
                                          //                       //       const EdgeInsets
                                          //                       //           .all(8.0),
                                          //                       //   child:
                                          //                       //       SelectWeekDays(
                                          //                       //     border: false,
                                          //                       //     boxDecoration:
                                          //                       //         BoxDecoration(
                                          //                       //       borderRadius:
                                          //                       //           BorderRadius
                                          //                       //               .circular(
                                          //                       //                   30.0),
                                          //                       //       gradient:
                                          //                       //           const LinearGradient(
                                          //                       //         begin: Alignment
                                          //                       //             .topLeft,
                                          //                       //         colors: [
                                          //                       //           Color(
                                          //                       //               0xFFE55CE4),
                                          //                       //           Color(
                                          //                       //               0xFFBB75FB)
                                          //                       //         ],
                                          //                       //         tileMode:
                                          //                       //             TileMode
                                          //                       //                 .repeated, // repeats the gradient over the canvas
                                          //                       //       ),
                                          //                       //     ),
                                          //                       //      onSelect: (List<String> values) {
                                          //                       //       print(values);
                                          //                       //           setState(() {
                                          //                       //            ldays = values;
                                          //                       //           });

                                          //                       //     },
                                          //                       //     days: _days,
                                          //                       //   ),
                                          //                       // ),
                                          //                       Padding(
                                          //                         padding:
                                          //                             const EdgeInsets
                                          //                                     .only(
                                          //                                 bottom:
                                          //                                     15.0),
                                          //                         child:
                                          //                             RoundedButton(
                                          //                           color: Colors
                                          //                               .green,
                                          //                           onPressed:
                                          //                               () async {
                                          //                             createplagehoraire(
                                          //                                 populations[
                                          //                                         index]
                                          //                                     .id);
                                          //                           },
                                          //                           title: 'Edit',
                                          //                         ),
                                          //                       ),
                                          //                     ]),
                                          //               ));
                                          //         });
                                          //       });
                                          // }

                                        }
                                        ;
                                      })
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        )));

    //   FutureBuilder(
    //     // future: getpopulation(),
    //     builder: (contect, snapshot) {
    //       if (populations == null) {
    //         return const Center(child: CircularProgressIndicator());
    //       } else {
    //         return ListView.builder(
    //           itemCount: populations == null ? 0 : populations.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             return Padding(
    //                 padding: const EdgeInsets.all(5.0),
    //                 child: Card(
    //                     elevation: 0.5,
    //                     child : Column(
    //                       children: [
    //                         SizedBox(height: 3,),
    //                         Row(
    //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                   SizedBox(width: 2),
    //                                 Text(
    //                                   populations[index].name,
    //                                   style: const TextStyle(
    //                                     fontSize: 20.0,
    //                                     fontWeight: FontWeight.w400,
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                       ],
    //                     )));
    //           },
    //         );
    //       }
    //     },
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

  showPlageHoraire(BuildContext context, id) async {
    ldays = [];
    selectDays = [];
    startDate = "";
    _checked = false;
    _checked1 = false;
    _checked2 = false;
    _checked3 = false;
    _checked4 = false;
    _checked5 = false;
    _checked6 = false;
    endDate = "";
    await getPlageHoraire(id).then((value) {
      setState(() {
        plageHoraire = value;
        if (value.applies_at != "*") {
          var data = value.applies_at.split(',"days":');
          Map valueMap = json.decode(data[0] + '}');
          startDate = valueMap['hours']['start_hour'];
          endDate = valueMap['hours']['end_hour'];
          selectDays = data[1].replaceAll('{', '').split(",}}}");
          for (var element in selectDays) {
            if (element.contains('L') == true) {
              setState(() {
                _checked = true;
              });
            }
            if (element.contains('Ma') == true) {
              setState(() {
                _checked1 = true;
              });
            }
            if (element.contains('Me') == true) {
              setState(() {
                _checked2 = true;
              });
            }
            if (element.contains('J') == true) {
              setState(() {
                _checked3 = true;
              });
            }
            if (element.contains('V') == true) {
              setState(() {
                _checked4 = true;
              });
            }
            if (element.contains('S') == true) {
              setState(() {
                _checked5 = true;
              });
            }
            if (element.contains('D') == true) {
              setState(() {
                _checked6 = true;
              });
            }
          }
        }
      });
    });
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TimeOfDay timeEnd = TimeOfDay.now();
        TimeOfDay time = TimeOfDay.now();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Plage Horaire',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: timeCtl, // add this line.
                            decoration: InputDecoration(
                              labelText: 'Start time*',
                            ),
                            onTap: () async {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              TimeOfDay? picked = await showTimePicker(
                                  context: context, initialTime: time);
                              if (picked != null && picked != time) {
                                timeCtl.text =
                                    picked.toString(); // add this line.
                                setState(() {
                                  time = picked;
                                });
                              }
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: endCtl, // add this line.
                            decoration: InputDecoration(
                              labelText: 'End time*',
                            ),
                            onTap: () async {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              TimeOfDay? picked = await showTimePicker(
                                  context: context, initialTime: timeEnd);
                              if (picked != null && picked != timeEnd) {
                                endCtl.text =
                                    picked.toString(); // add this line.
                                setState(() {
                                  timeEnd = picked;
                                });
                              }
                            },
                          )),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('L'),
                                    Checkbox(
                                      value: _checked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _checked = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Ma'),
                                    Checkbox(
                                      value: _checked1,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _checked1 = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Me'),
                                    Checkbox(
                                      value: _checked2,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _checked2 = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('J'),
                                    Checkbox(
                                      value: _checked3,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _checked3 = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('V'),
                                    Checkbox(
                                      value: _checked4,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _checked4 = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('S'),
                                    Checkbox(
                                      value: _checked5,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _checked5 = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('D'),
                                    Checkbox(
                                      value: _checked6,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _checked6 = value!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("no");
                  },
                ),
                TextButton(
                  child: const Text('Add Plage',
                      style: TextStyle(color: Colors.green)),
                  onPressed: () async {
                    createplagehoraire(id, time, timeEnd);
                    //Navigator.of(context).pop("yes");
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  _showAlertDialogAdd(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add population',
            style: TextStyle(
              color: primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  key: new Key('Population name'),
                  controller: name,
                  cursorColor: Color(0xFF0D47A1),
                  style: TextStyle(color: Color(0xFF0D47A1)),
                  decoration: InputDecoration(
                    labelText: 'Population name',
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  readOnly: true,
                  controller: startDateText,
                  onTap: () async {
                    var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                    if (date == null) {
                      print(
                          "Hi bro, i came from cancel button or via click outside of datepicker");
                    } else {
                      var datePicker =
                          "${date.toLocal().year}/${date.toLocal().month}/${date.toLocal().day}";
                      setState(() {
                        startDateText.text = datePicker;
                      });
                    }
                  },
                  //suffixIcon apresle text w prefixIcon avant le text
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.calendar_today_sharp,
                        size: 18.0,
                      ),
                      labelText: 'Start Date'),
                ),
              ),
            ]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop("no");
              },
            ),
            TextButton(
              child: const Text('Add population',
                  style: TextStyle(color: Colors.green)),
              onPressed: () async {
                createpopulation();
                //Navigator.of(context).pop("yes");
              },
            ),
          ],
        );
      },
    );
  }

  createpopulation() async {
    String def = "default";
    String name_configgroup =
        def + '_' + name.text.toLowerCase().replaceAll(' ', '_');
    var data = {
      "name": name.text,
      "name_configgroup": name_configgroup,
      "first_day": DateFormat('yyyy-MM-dd').format(_selectedDate),
    };
    http.Response res = await CallApi().postData(data, 'createpopulation');
    var body = jsonDecode(res.body);
    if (body['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Success .. !"),
        duration: Duration(seconds: 2),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PopulationScreen(),
        ),
      );
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickerTime = await _showTimePicker();
    String _formatedTime = pickerTime.format(context);
    if (pickerTime == null) {
    } else if (isStartTime == true) {
      setState(() {
        _startTime = pickerTime;
        print(_startTime);
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

  createplagehoraire(_id, time, endTime) async {
    int id = _id;
    String start_time = "${_startTime.hour}" + ':' + "${_startTime.minute}";
    String end_time = "${_endTime.hour}" + ':' + "${_endTime.minute}";
    List<String> test = [];
    if (_checked == true) {
      test.add('L');
    }
    if (_checked1 == true) {
      test.add('Me');
    }
    if (_checked2 == true) {
      test.add('Ma');
    }
    if (_checked3 == true) {
      test.add('J');
    }
    if (_checked4 == true) {
      test.add('V');
    }
    if (_checked5 == true) {
      test.add('S');
    }
    if (_checked6 == true) {
      test.add('D');
    }

    print(start_time);
    print(end_time);
    print(ldays);
    String days = '';
    for (int i = 0; i < test.length; i++) {
      days = days + test[i] + ',';
      print("days");
      print(days);
    }
    print(days);
    var data = {
      "start_time": DateFormat("HH:mm")
          .format(new DateTime(2000, 1, 1, time.hour, time.minute)),
      "end_time": DateFormat("HH:mm")
          .format(new DateTime(2000, 1, 1, endTime.hour, endTime.minute)),
      "days": days,
    };
    print(data);
    http.Response res =
        await CallApi().postData(data, 'createplagehoraire/$id');
    var body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(body['message']),
      duration: Duration(seconds: 3),
    ));
  }

  Future<String?> _showAlertDialog(BuildContext context, int id) async {
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Delete !',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete population ?'),
                  const Text('Press yes to delete!'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop("no");
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(milliseconds: 2000),
                      content: Text(
                        'User Deleted successfully',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  await delete(id);
                },
              ),
            ],
          );
        });
  }

  delete(id) async {
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(
                'Delete population !',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Are you sure you want to delete population ?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop("no");
                  },
                ),
                TextButton(
                    child: const Text('Yes'),
                    onPressed: () async {
                      http.Response response =
                          await CallApi().deleteData('deletepopulation/$id');
                      Map responseMap = jsonDecode(response.body);
                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 2000),
                            content: Text(
                              'Population Deleted successfully',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        getpopulation();
                        Navigator.pop(context);
                      } else {
                        print(responseMap);
                      }
                    })
              ]);
        });
  }

  updatevue(BuildContext context, id, _name, date) async {
        name = TextEditingController(
        text: _name);
             startDateText = TextEditingController(
        text: date.toString());
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Edit population',
            style: TextStyle(
              color: primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  key: new Key('Population name'),
                  controller: name,
                  cursorColor: Color(0xFF0D47A1),
                  style: TextStyle(color: Color(0xFF0D47A1)),
                  decoration: InputDecoration(
                    labelText: 'Population name',
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  readOnly: true, 
                  controller: startDateText,
                  onTap: () async {
                    var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                    if (date == null) {
                      print(
                          "Hi bro, i came from cancel button or via click outside of datepicker");
                    } else {
                      var datePicker =
                          "${date.toLocal().year}/${date.toLocal().month}/${date.toLocal().day}";
                      setState(() {
                        startDateText.text = datePicker;
                      });
                    }
                  },
                  //suffixIcon apresle text w prefixIcon avant le text
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.calendar_today_sharp,
                        size: 18.0,
                      ),
                      labelText: 'Start Date'),
                ),
              ),
            ]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop("no");
              },
            ),
            TextButton(
              child: const Text('Edit population',
                  style: TextStyle(color: Colors.green)),
              onPressed: () async {
                update(id);
                //Navigator.of(context).pop("yes");
              },
            ),
          ],
        );
      },
    );
  }

  update(id) async {
    var data = {
      'name': name.text,
      'date': _selectedDate.toString(),
    };
    print(data);
    http.Response res = await CallApi().putData(data, 'updatepopulation/$id');
    var body = json.decode(res.body);
    print(body);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 2000),
        content: Text(
          'Population Updated successfully',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
        getpopulation();
        Navigator.pop(context);
    
  }
}
