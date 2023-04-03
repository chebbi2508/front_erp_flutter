import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe/models/user.dart';
import 'package:pfe/navDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/population.dart';
import '../../services/callapi.dart';
import '../../theme/colors.dart';
import 'components/add_new_user.dart';
import 'components/add_user.dart';
import 'components/user_data.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  //getuser info
    getusers() async {
    http.Response response = await CallApi().getData('getusers');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      setState(() {
        users = ll.map<User>((json) => User.fromJson(json)).toList();
      });
    }
    return users;
  }

  var userData;
  _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
    return userData;
  }
  delete(int id) async {
  http.Response response = await CallApi().deleteData('deleteuser/$id');
  Map responseMap = jsonDecode(response.body);
  print(responseMap);
  if (response.statusCode == 200) {
    print(responseMap);
    getusers();
                                     
  } else {
    print(responseMap);
  }
}

  List jobssuperadmin = ['admin', 'user', 'superadmin'];
  List jobsadmin = ['admin', 'user'];
  late String population = "";
  List users = [];

  List populations = [];
  List nomplanning = [];
  getpopulation() async {
    http.Response response = await CallApi().getData('getpopulations');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      populations =
          ll.map<Population>((json) => Population.fromJson(json)).toList();

      setState(() {
        nomplanning =
            populations.map((populations) => populations.name).toList();
      });
    }
    return nomplanning;
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    getusers().then(
      (users) {
        setState(() {
          users;
        });
      },
    );
    getpopulation().then(
      (nomplanning) {
        setState(() {
          populations;
          nomplanning;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Users"),
          ),
        );
      }
    } else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfileUser(
                      populations: nomplanning,
                      iduser: userData['id'],
                      jobs: jobssuperadmin)),
            );
            if (result == 'success') {
              setState(() {
                getusers();
              });
            }
          },
          backgroundColor: kSeconderyColor,
          child: const Icon(
            Icons.add,
            size: 25.0,
          ),
        ),
        appBar: AppBar(
          title: const Text("Users"),
        ),
        backgroundColor: backgroundColor,
        drawer: NavDrawer(context),
        body: FutureBuilder(
          // future: getData(),
          builder: (contect, snapshot) {
            if (users.length == null && populations.length == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (userData['job'] != "superadmin") {
                users = users
                    .where((users) => users.created_by == userData['id'])
                    .toList();
              }

              return ListView.builder(
                itemCount: users == null ? 0 : users.length,
                itemBuilder: (BuildContext context, int index) {
                  for (int i = 0; i < populations.length; i++) {
                    List idactivites = populations
                        .where((populations) =>
                            populations.id == users[index].fk_population)
                        .toList();
                    population = idactivites[0].name;
                  }
                  return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          trailing: Wrap(
                            spacing: 0,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  color: kSeconderyColor,
                                  onPressed: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileUser(
                                                      populations: nomplanning,
                                                      iduser: userData['id'],
                                                      firstname: users[index]
                                                          .firstname,
                                                      lastname:
                                                          users[index].lastname,
                                                      status:
                                                          users[index].status,
                                                      job: users[index].job,
                                                      id: users[index].id,

                                                      //password: users[index].password,
                                                      population: population,
                                                      email: users[index].email,
                                                      jobs: jobsadmin)),
                                        )
                                      }),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    _showAlertDialog(
                                        contect,
                                        users[index].firstname,
                                        users[index].id);
                         
                              
                                  }),
                            ],
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 231, 222, 222),
                            radius: 30.0,
                            child: Icon(
                              Icons.person,
                              size: 30.0,
                              // color: Color(0xFF404040),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                'firstname: ',
                                style: TextStyle(color: primaryColor),
                              ),
                              const SizedBox(width: 2),
                              Text(users[index].firstname),
                              // const SizedBox(width: 1),
                              //Text(users[index].lastname)
                            ],
                          ),
                          onTap: () {
                            detailsUser(users[index], context, population);
                          }));

                  // InkWell(

                  //   onTap: () async {
                  //     print(users[index].firstname);
                  //     print(nomplanning);
                  //     final result = await showModalBottomSheet(
                  //       context: context,
                  //       builder: (context) {
                  //         return UserDataScreen(
                  //           firstname: users[index].firstname,
                  //           lastname: users[index].lastname,
                  //           job: users[index].job,
                  //           email: users[index].email,
                  //           status: users[index].status,
                  //           iduser: userData['id'],
                  //           id: users[index].id, popu: population, popus: nomplanning, jobs: jobssuperadmin,
                  //         );
                  //       },
                  //       isScrollControlled: true,
                  //     );
                  //     if (result == 'yes') {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //           duration: Duration(milliseconds: 2000),
                  //           content: Text(
                  //             'User Deleted successfully',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 15.0,
                  //             ),
                  //           ),
                  //           backgroundColor: Colors.red,
                  //         ),
                  //       );
                  //       setState(() {
                  //         getusers();
                  //       });
                  //     }
                  //     if (result == 'success') {
                  //       setState(() {
                  //         getusers();
                  //       });
                  //     }
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       vertical: 10.0,
                  //       horizontal: 6.0,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Row(children: [
                  //                Text(
                  //               users[index].firstname,
                  //               style: const TextStyle(
                  //                 fontSize: 20.0,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //                 Text(
                  //               users[index].lastname,
                  //               style: const TextStyle(
                  //                 fontSize: 20.0,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //             ],),

                  //             Text(
                  //               users[index].email,
                  //               style: const TextStyle(
                  //                 fontSize: 15.0,
                  //                 color: Colors.blueGrey,
                  //                 fontWeight: FontWeight.w300,
                  //               ),
                  //             ),
                  //             Text(
                  //               population ,
                  //               style: const TextStyle(
                  //                 fontSize: 15.0,
                  //                 color: Color.fromRGBO(78, 164, 207, 1),
                  //                 fontWeight: FontWeight.w800,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Text(
                  //           users[index].job,
                  //           style: const TextStyle(
                  //             fontSize: 15.0,
                  //             fontWeight: FontWeight.w900,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                },
              );
            }
          },
        ),
      );
    }
  }
  _showAlertDialog(BuildContext context, String userName, int id) async {
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
              Text('Are you sure you want to delete user: $userName ?'),
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
              await delete(id);
             
            },
          ),
        ],
      );
    },
  );
}
}

detailsUser(element, context, population) {
  showDialog(
      context: context,
      builder: (BuildContext contextDetails) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
                child: Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: 300.0,
                        width: 1000.0,
                        child: Stack(children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 350.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 43,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "User details",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          SingleChildScrollView(
                            padding: EdgeInsets.all(2.0),
                            child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      SizedBox(
                                        height: 50.0,
                                      ),
                                      Row(children: [
                                        Text("Name: ",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15.0,
                                            )),
                                        element.firstname == null
                                            ? Text('----')
                                            : Text(element.firstname)
                                      ]),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(children: [
                                        Text("lastname: ",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15.0,
                                            )),
                                        element.lastname == null
                                            ? Text('----')
                                            : Text(element.lastname)
                                      ]),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(children: [
                                        Text("Status: ",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15.0,
                                            )),
                                        element.status == null
                                            ? Text('----')
                                            : Text(element.status),
                                      ]),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(children: [
                                            Text("Job: ",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15.0,
                                                )),
                                            element.job == null
                                                ? Text('----')
                                                : Text(element.job
                                                    .replaceAll(' ', '')),
                                          ])),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(children: [
                                        Text("Population: ",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15.0,
                                            )),
                                        population == null
                                            ? Text('----')
                                            : Text(population),
                                      ]),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(children: [
                                        Text("Email: ",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15.0,
                                            )),
                                        element.email == null
                                            ? Text('----')
                                            : Text(element.email),
                                      ]),
                                    ])),
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    //  color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: 100.0,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  Colors.white, // background
                                              onPrimary:
                                                  Colors.blue, // foreground
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment(1.05, -1.05),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ])))));
      });
 }


