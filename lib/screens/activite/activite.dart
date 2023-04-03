import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:pfe/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/activite.dart';
import '../../navDrawer.dart';
import '../../services/callapi.dart';

class ActiviteScreen extends StatefulWidget {
  const ActiviteScreen({Key? key}) : super(key: key);

  @override
  State<ActiviteScreen> createState() => _ActiviteScreenState();
}

class _ActiviteScreenState extends State<ActiviteScreen> {
  //getuser info
  var userData;
  var _selected;
  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  List<Activite> activites = [];
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

// create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController description = TextEditingController();
  List types = ['important', 'urgence'];
  @override
  void initState() {
    super.initState();
    _getUserInfo();
    getactivites().then(
      (activites) {
        setState(() {
          activites;
          nomactivite;
        });
      },
    );
  }

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
          backgroundColor: kSeconderyColor, foregroundColor: Colors.white,
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
            //           child: SingleChildScrollView(
            //             child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   MyInputtext(
            //                     title: "Activity Name",
            //                     hint: "Activity Name",
            //                     controller: name,
            //                   ),
            //                   MyInputtext(
            //                     title: "Description",
            //                     hint: "Description",
            //                     controller: description,
            //                   ),
            //                   DropDownField(
            //                     //controller: ligneselected,
            //                     hintText: "Type",
            //                     enabled: true,
            //                     controller: type,
            //                     items: types.cast<String>(),
            //                     onValueChanged: (value) {
            //                       type.text = value;
            //                     },
            //                   ),
            //                   RoundedButton(
            //                     color: currentColor,
            //                     onPressed: () async {
            //                       showDialog(
            //                           context: context,
            //                           builder: (BuildContext context) {
            //                             return AlertDialog(
            //                               title: const Text('Pick a color!'),
            //                               content: SingleChildScrollView(
            //                                 child: ColorPicker(
            //                                   pickerColor: pickerColor,
            //                                   onColorChanged: changeColor,
            //                                 ),
            //                               ),
            //                               actions: <Widget>[
            //                                 ElevatedButton(
            //                                   child: const Text('Got it'),
            //                                   onPressed: () {
            //                                     setState(() =>
            //                                         currentColor = pickerColor);
            //                                     print(currentColor);
            //                                     Navigator.of(context).pop();
            //                                   },
            //                                 ),
            //                               ],
            //                             );
            //                           });
            //                     },
            //                     title: 'color',
            //                   ),
            //                   RoundedButton(
            //                     color: kSeconderyColor,
            //                     onPressed: () async {
            //                       createactivite();
            //                     },
            //                     title: 'Add Activity',
            //                   ),
            //                 ]),
            //           ));
            //     });

            // if (result == 201) {
            //   setState(() {
            //     getData();
            //   });
            // }
          },
          //   label: Text('Add'),
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppBar(
        title: const Text("Activities"),
      ),
      drawer: NavDrawer(context),
      body: FutureBuilder(
        // future: getpopulation(),
        builder: (contect, snapshot) {
          if (activites == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 4.0),
              itemCount: activites == null ? 0 : activites.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    elevation: 0.1,
                    // color: Color(activites[index].color),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            _showAlertDialog(context, activites[index].id);
                          },
                          child: Container(
                            // decoration: BoxDecoration(
                            //   border: Border(
                            //       right: BorderSide(
                            //     color: Color(activites[index].color),
                            //     width: 4,
                            //   )),
                            // ),
                            decoration: new BoxDecoration(
                                 border: Border(
                                    top: BorderSide(
                                        color: Color(activites[index].color),
                                        width: 2))),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 6.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_activity,
                                  size: 35,
                                  color: primaryColor,
                                ),
                                Text(
                                  'Name : ${activites[index].name}',
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: kSeconderyColor),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Description: ${activites[index].description}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: null,
                                ),
                              ],
                            ),
                          ),
                        )));
              },
            );
          }
        },
      ),
    );
  }

  _showAlertDialogAdd(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add activity',
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
                  key: new Key('Activity name'),
                  controller: name,
                  cursorColor: Color(0xFF0D47A1),
                  style: TextStyle(color: Color(0xFF0D47A1)),
                  decoration: InputDecoration(
                    labelText: 'Activity name',
                    labelStyle: TextStyle(
                      fontSize: 17,
                      // Tweak this 1,2 moves label bottom-> -1,-2 moves label upwards
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.file_copy,
                      color: Colors.grey[800],
                      size: 22,
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
                  key: new Key('Description'),
                  controller: description,
                  cursorColor: Color(0xFF0D47A1),
                  style: TextStyle(color: Color(0xFF0D47A1)),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      fontSize: 17,
                      // Tweak this 1,2 moves label bottom-> -1,-2 moves label upwards
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.details,
                      color: Colors.grey[800],
                      size: 22,
                    ),
                    border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF0D47A1), width: 1.0)),
                  ),
                ),
              ),

              // MyInputtext(
              //   title: "Activity Name",
              //   hint: "Activity Name",
              //   controller: name,
              // ),
              // MyInputtext(
              //   title: "Description",
              //   hint: "Description",
              //   controller: description,
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: DropdownButtonFormField<dynamic>(
                  isExpanded: true,
                  validator: (value) => value == null ? 'choose type' : null,
                  hint: Text("Type *"),
                  items: types.map((dynamic item) {
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
                      _selected = val;
                    });
                  },
                  value: _selected,
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      minimumSize: const Size.fromHeight(30), // NEW
                    ),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Pick a color!'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: changeColor,
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Got it'),
                                  onPressed: () {
                                    setState(() => currentColor = pickerColor);
                                    print(currentColor);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Text(' Choose color'),
                  )),
              // RoundedButton(
              //   color: kSeconderyColor,
              //   onPressed: () async {

              //   },
              //   title: '',
              // ),
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
              child: const Text('Add Activity'),
              onPressed: () async {
                createactivite();
                //Navigator.of(context).pop("yes");
              },
            ),
          ],
        );
      },
    );
  }

  createactivite() async {
    final String code = 'ac-code' + Random().nextInt(1000).toString();
    var data = {
      'name': name.text,
      'description': description.text,
      'type': _selected,
      'code': code,
      'color': currentColor.value,
      'created_by': userData['id'],
    };

    print(data);
    http.Response res = await CallApi().postData(data, 'postactivites');
    var body = jsonDecode(res.body);
    print(body);
    if (body['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Success .. !"),
        duration: Duration(seconds: 2),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActiviteScreen(),
        ),
      );
    }
  }

  deleteactivity(id) async {
    http.Response response = await CallApi().deleteData('deleteactivite/$id');
    Map responseMap = jsonDecode(response.body);
    print(responseMap);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Text(
            'Activity Deleted successfully',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      getactivites();
    } else {
      print(responseMap);
    }
  }

  Future<String?> _showAlertDialog(BuildContext context, int id) async {
    return showDialog<String>(
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
                Text('Are you sure you want to delete activity?'),
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
                Navigator.of(context).pop("yes");
                await deleteactivity(id);
              },
            ),
          ],
        );
      },
    );
  }
}
