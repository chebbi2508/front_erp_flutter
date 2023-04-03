import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfe/screens/activite/activite.dart';
import 'package:pfe/screens/planning/planning.dart';
import 'package:pfe/screens/pointage/add_pointing_super.dart';
import 'package:pfe/screens/pointage/add_pointing_user.dart';
import 'package:pfe/screens/societes/societe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../accueil/accueil.dart';
import '../models/population.dart';
import '../screens/login2/login.dart';
import '../screens/planning/add_task.dart';
 import '../screens/planning/add_task_super.dart';
import '../screens/planning/add_task_user.dart';
import '../screens/planning/planning_enattend.dart';
import '../screens/pointage/add_pointing.dart';
import '../screens/pointage/pointage.dart';
import '../screens/populations/population.dart';
import '../screens/user/components/add_user.dart';
import '../screens/user/user.dart';
import '../services/callapi.dart';

class Mydrawer extends StatefulWidget {
  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  //getuser info
  var userData;
  List jobssuperadmin = ['admin', 'user', 'superadmin'];
  List jobsadmin = ['admin', 'user'];

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  List populations = [];
  List nompopulation = [];
  getpopulation() async {
    http.Response response = await CallApi().getData('getpopulations');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
      populations =
          ll.map<Population>((json) => Population.fromJson(json)).toList();
          if(mounted){
     setState(() {
        nompopulation =
            populations.map((populations) => populations.name).toList();
      });
    }
          }
 
    // print(populations);
    print('name $nompopulation');
    return nompopulation;
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    getpopulation().then(
      (nompopulation) {
        setState(() {
          populations;
          nompopulation;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            width: 150,
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName:
                      Text(userData != null ? '${userData['firstname']}' : ''),
                  accountEmail:
                      Text(userData != null ? '${userData['email']}' : ''),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,size: 30.0,),
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 61, 80, 225),
                  ),
                ),
                CustomListTile(
                    Icons.home,
                    () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ResourceView(),
                              ))
                        },
                    'Accueil'),
                ExpansionTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    title: const Text(
                      'Utilisateurs',
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      CustomListTile(
                          Icons.person_search,
                          () => {
                                if (userData['job'] == 'admin' ||
                                    userData['job'] == 'superadmin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              UsersScreen(),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          "Vous n'avez pas l'accée pour accéder à cette interface"),
                                      duration: Duration(seconds: 2),
                                    ))
                                  }
                              },
                          'Liste Utilisateurs'),
                      CustomListTile(
                          Icons.person_add,
                          () => {
                                if (userData['job'] == 'admin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddModifyUserScreen(
                                            jobs: jobsadmin,
                                            iduser: userData['id'],
                                            populations: nompopulation,
                                          ),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddModifyUserScreen(
                                            jobs: jobssuperadmin,
                                            iduser: userData['id'],
                                            populations: nompopulation,
                                          ),
                                        ))
                                  }
                              },
                          'ajouter Utilisateur'),
                    ]),
                ExpansionTile(
                    leading: const Icon(
                      Icons.local_activity,
                      color: Colors.black,
                    ),
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    title: const Text(
                      'Activites',
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      CustomListTile(
                          Icons.local_activity_sharp,
                          () => {
                                if (userData['job'] == 'admin' ||
                                    userData['job'] == 'superadmin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ActiviteScreen(),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          "Vous n'avez pas l'accée pour accéder à cette interface"),
                                      duration: Duration(seconds: 2),
                                    ))
                                  }
                              },
                          'Activities'),
                    ]),
                ExpansionTile(
                    leading: Icon(
                      Icons.comment,
                      color: Colors.black,
                    ),
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    title: const Text(
                      'Populations',
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      CustomListTile(
                          Icons.add_comment,
                          () => {
                                if (userData['job'] == 'admin' ||
                                    userData['job'] == 'superadmin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const PopulationScreen(),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          "Vous n'avez pas l'accée pour accéder à cette interface"),
                                      duration: Duration(seconds: 1),
                                    ))
                                  }
                              },
                          'Liste Populations'),
                    ]),
                ExpansionTile(
                    leading: const Icon(
                      Icons.task,
                      color: Colors.black,
                    ),
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    title: const Text(
                      'Planification',
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      CustomListTile(
                          Icons.add_task,
                          () => {
                                if (userData['job'] == 'admin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const AddTaskPage(),
                                        ))
                                  }
                                else if (userData['job'] == 'superadmin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const AddTaskSuperPage(),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const AddTaskUserPage(),
                                        ))
                                  }
                              },
                          'ajouter Planification'),
                      CustomListTile(
                          Icons.update,
                          () => {
                                if (userData['job'] == 'admin' ||
                                    userData['job'] == 'superadmin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PopulationEtatScreen(),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          "Vous n'avez pas l'accée pour accéder à cette interface"),
                                      duration: Duration(seconds: 1),
                                    ))
                                  }
                              },
                          'Etat de planification'),
                      CustomListTile(
                          Icons.calendar_view_month,
                          () => {
                                if (userData['job'] == 'admin' ||
                                    userData['job'] == 'superadmin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CalendarPage(),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          "Vous n'avez pas l'accée pour accéder à cette interface"),
                                      duration: Duration(seconds: 1),
                                    ))
                                  }
                              },
                          'Affichage Planification'),
                    ]),
                ExpansionTile(
                    leading: const Icon(
                      Icons.access_time,
                      color: Colors.black,
                    ),
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    title: const Text(
                      'Pointage',
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      CustomListTile(
                          Icons.add_task,
                          () => {
                              if (userData['job'] == 'admin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const AddTaskPointingPage(),
                                        ))
                                  }
                                else if (userData['job'] == 'superadmin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const AddPointingSuperPage(),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const AddPointingUserPage(),
                                        ))
                                  }
                              },
                          'ajouter pointage'),
                      CustomListTile(
                          Icons.calendar_view_month,
                          () => {
                                if (userData['job'] == 'admin' ||
                                    userData['job'] == 'superadmin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                             const  PointageView(),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          "Vous n'avez pas l'accée pour accéder à cette interface"),
                                      duration: Duration(seconds: 1),
                                    ))
                                  }
                              },
                          'Affichage Pointage'),
                    ]),
                ExpansionTile(
                    leading: Icon(
                      Icons.work,
                      color: Colors.black,
                    ),
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    title: Text(
                      'Societe',
                      style: TextStyle(color: Colors.black),
                    ),
                    children: [
                      CustomListTile(
                          Icons.work_history,
                          () => {
                                if (userData['job'] == 'superadmin')
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SocieteScreen(),
                                        ))
                                  }
                                else
                                  {
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          "Vous n'avez pas l'accée pour accéder à cette interface"),
                                      duration: const Duration(seconds: 1),
                                    ))
                                  }
                              },
                          'Societe'),
                    ]),
                CustomListTile(Icons.logout, () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.clear();
                  await pref.remove('token');
                  // Then close the drawer
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ));
                }, 'Déconnexion'),
              ],
            )));
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function() onTap;
  CustomListTile(this.icon, this.onTap, this.text);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Color.fromRGBO(19, 124, 163, 64),
          onTap: onTap,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
