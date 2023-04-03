import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:pfe/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Societe.dart';
import '../../models/user.dart';
import '../../navDrawer.dart';
import '../../services/callapi.dart';

class SocieteScreen extends StatefulWidget {
  const SocieteScreen({Key? key}) : super(key: key);
  @override
  State<SocieteScreen> createState() => _SocieteState();
}

class _SocieteState extends State<SocieteScreen> {
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

  List<Societe> societes = [];

  getsocietes() async {
    String myUrl = "http://10.0.2.2:8000/api/getsociete";
    http.Response response = await http.get(Uri.parse(myUrl));
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      Iterable ll = jsondata;

      societes = ll.map<Societe>((json) => Societe.fromJson(json)).toList();
      setState(() {
        societes = societes
            .where((societes) => societes.user_id == userData['id'])
            .toList();
      });
    }
    print(societes);
    return societes;
  }

  int? user_id;

  TextEditingController name = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController user = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    getsocietes().then(
      (societes) {
        setState(() {
          societes;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
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
          //                   title: "Societe Name",
          //                   hint: "Societe Name",
          //                   controller: name,
          //                 ),
          //                 MyInputtext(
          //                   title: "Adresse",
          //                   hint: "Adresse",
          //                   controller: adresse,
          //                 ),
          //                 DropDownField(
          //                   //controller: ligneselected,
          //                   hintText: "Superadmin",
          //                   enabled: true,
          //                   controller: user,
          //                   items: nomusers.cast<String>(),
          //                   onValueChanged: (value) {
          //                     user.text = value;

          //                     for (int i = 0; i < lesuser.length; i++) {
          //                       List iduser = lesuser
          //                           .where((lesuser) =>
          //                               lesuser.firstname ==
          //                                   user.text.split(' ')[0] &&
          //                               lesuser.lastname ==
          //                                   user.text.split(' ')[1])
          //                           .toList();
          //                       user_id = iduser[0].id;
          //                     }
          //                   },
          //                 ),
          //                 RoundedButton(
          //                   color: kSeconderyColor,
          //                   onPressed: () async {
          //                     createsociete();
          //                   },
          //                   title: 'Add Societe',
          //                 ),
          //               ]));
          //     });
          // // if (result == 201) {
          //   setState(() {
          //     getData();
          //   });
          // }
        },
        backgroundColor: kSeconderyColor,
        child: const Icon(
          Icons.add,
          size: 25.0,
        ),
      ),
      appBar: AppBar(
        title: const Text("Societes"),
      ),
      drawer: NavDrawer(context),
      body: FutureBuilder(
        // future: getpopulation(),
        builder: (contect, snapshot) {
          if (societes == null) {
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
              itemCount: societes == null ? 0 : societes.length,
              itemBuilder: (BuildContext context, int index) {
                String superadmin = '';
                for (int i = 0; i < lesuser.length; i++) {
                  List idactivites = lesuser
                      .where((lesuser) => lesuser.id == societes[index].user_id)
                      .toList();
                  superadmin =
                      idactivites[0].firstname + ' ' + idactivites[0].lastname;
                }
                ;

                return Card(
                    elevation: 0.1,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () async {
                            _showAlertDialog(context, societes[index].id);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 6.0,
                            ),
                            child:SingleChildScrollView(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.share,
                                  size: 40,
                                 ),
                                SizedBox(height: 10.0,),
                                Text(
                                  'Name :  ${societes[index].name} ',
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: kSeconderyColor),
                                ),   SizedBox(height: 6.0,),
                                Text(
                                  'Adresse:  ${societes[index].adresse}',
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: null,
                                ),   SizedBox(height: 6.0,),
                                Text(
                                  'Created by:  $superadmin',
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: null,
                                ),
                              ],
                            ),
                          ),
                        ))));
              },
            );
          }
        },
      ),
    );
  }

  createsociete() async {
    var data = {
      'name': name.text,
      'adresse': adresse.text,
      'user_id': userData["id"],
    };
    print(userData);
    print(data);
    http.Response res = await CallApi().postData(data, 'postsociete');
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
          builder: (context) => SocieteScreen(),
        ),
      );
    }
  }

  deletesociete(id) async {
    print(id);
    http.Response response = await CallApi().deleteData('deletesociete/$id');
    Map responseMap = jsonDecode(response.body);
    print(responseMap);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Text(
            'Societe Deleted successfully',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      getsocietes();
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
                Text('Are you sure you want to delete societe?'),
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
              onPressed: () {
                // Navigator.of(context).pop("yes");
                deletesociete(id);
              },
            ),
          ],
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
            'Add Societe',
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
                  key: new Key('Societe name'),
                  controller: name,
                  cursorColor: Color(0xFF0D47A1),
                  style: TextStyle(color: Color(0xFF0D47A1)),
                  decoration: InputDecoration(
                    labelText: 'Societe name',
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
                  key: new Key('Societe adresse'),
                  controller: adresse,
                  cursorColor: Color(0xFF0D47A1),
                  style: TextStyle(color: Color(0xFF0D47A1)),
                  decoration: InputDecoration(
                    labelText: 'Societe adresse',
                    labelStyle: TextStyle(
                      fontSize: 17,
                      // Tweak this 1,2 moves label bottom-> -1,-2 moves label upwards
                      fontWeight: FontWeight.w500,
                    ),
                    suffixIcon: Icon(
                      Icons.map,
                      size: 18,
                    ),
                    border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF0D47A1), width: 1.0)),
                  ),
                ),
              ),

              // connect user
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 20.0),
              //   child: nomusers != null
              //       ? DropdownButtonFormField<dynamic>(
              //           isExpanded: true,
              //           validator: (value) =>
              //               value == null ? 'choose Population' : null,
              //           hint: Text("Population *"),
              //           items: nomusers.map((dynamic item) {
              //             return new DropdownMenuItem<dynamic>(
              //                 child: Text(
              //                   item, //Names that the api dropdown contains
              //                   style: TextStyle(
              //                     fontSize: 16.0,
              //                   ),
              //                 ),
              //                 value: item //id projects
              //                 );
              //           }).toList(),
              //           onChanged: (var val) {
              //             setState(() {
              //               user.text = val;
              //               for (int i = 0; i < lesuser.length; i++) {
              //                 List iduser = lesuser
              //                     .where((lesuser) =>
              //                         lesuser.firstname ==
              //                             user.text.split(' ')[0] &&
              //                         lesuser.lastname ==
              //                             user.text.split(' ')[1])
              //                     .toList();
              //                 user_id = iduser[0].id;
              //               }
              //             });
              //           },
              //           value: user,
              //         )
              //       : Container(),
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
              child: const Text('Add Societe',
                  style: TextStyle(color: Colors.green)),
              onPressed: () async {
                createsociete();
                //    Navigator.of(context).pop("yes");
              },
            ),
          ],
        );
      },
    );
  }
}
