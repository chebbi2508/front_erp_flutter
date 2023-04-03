import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfe/screens/activite/activite.dart';
import 'package:pfe/screens/login2/login.dart';
import 'package:pfe/screens/planning/planning.dart';
import 'package:pfe/screens/pointage/pointage.dart';
import 'package:pfe/screens/populations/population.dart';
import 'package:pfe/screens/societes/societe.dart';
import 'package:pfe/screens/user/user.dart';
import 'package:pfe/services/callapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'accueil/accueil.dart';
import 'models/population.dart';
import 'theme/colors.dart';

class NavDrawer extends StatefulWidget {
  BuildContext contextPage;
  // NavDrawer(contextPage : BuildContext context);
  NavDrawer(@required this.contextPage);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

int selectedIndex = 0;

class _NavDrawerState extends State<NavDrawer> {
  //getuser info
  var userData;
  List jobssuperadmin = ['admin', 'user', 'superadmin'];
  List jobsadmin = ['admin', 'user'];
  var typeUser;

   _getUserInfo() async {
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
      if (mounted) {
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
     SharedPreferences.getInstance().then((_perf) {
      typeUser = _perf.getString("type")!;
    });
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
      child: ListView(
        padding: EdgeInsets.only(bottom: 22.0),
        children: <Widget>[
          _createHeader(),
          if(typeUser  == "superadmin" || typeUser  == "admin")...[
            _createDrawerItem(
              icon: Icons.home,
              text: 'Accueil',
              subTitle: '',
              expanded: false,
              isSelected: selectedIndex == 10,
              onTap: () {
                setState(() {
                  selectedIndex = 10;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ResourceView(),
                    ));
              }),
          _createDrawerItem(
              icon: Icons.people,
              text: 'Utilisateurs',
              expanded: true,
              subTitle: 'Liste des utilisateurs',
              isSelected: selectedIndex == 14,
              onTap: () {
                setState(() {
                  selectedIndex = 14;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsersScreen(),
                    ));
              }),
          _createDrawerItem(
              icon: Icons.local_activity,
              text: 'Activites',
              subTitle: 'Liste d\'activités',
              expanded: true,
              isSelected: selectedIndex == 2,
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ActiviteScreen(),
                    ));
              }),
          _createDrawerItem(
              icon: Icons.add_comment,
              text: 'Populations',
              subTitle: 'Liste des populations',
              expanded: true,
              isSelected: selectedIndex == 4,
              onTap: () {
                setState(() {
                  selectedIndex = 4;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const PopulationScreen(),
                    ));
              }),
       
          ],
          _createDrawerItem(
              icon: Icons.task,
              text: 'Planification',
              subTitle: 'Liste des planifications',
              expanded: true,
              isSelected: selectedIndex == 8,
              onTap: () {
                setState(() {
                  selectedIndex = 8;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CalendarPage(),
                    ));
              }),
          _createDrawerItem(
              icon: Icons.list_alt_rounded,
              text: 'Pointage',
              subTitle: 'Liste des pointages',
              expanded: true,
              isSelected: selectedIndex == 16,
              onTap: () {
                setState(() {
                  selectedIndex = 16;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const PointageView(),
                    ));
              }),
           if(typeUser  == "superadmin")
          _createDrawerItem(
              icon: Icons.device_hub,
              expanded: true,
              text: 'Societe',
              subTitle: 'Liste des sociétes',
              isSelected: selectedIndex == 5,
              onTap: () {
                setState(() {
                  selectedIndex = 5;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SocieteScreen(),
                    ));
              }),
          Container(height: 1, color: Colors.grey),
          _createDrawerItem(
              icon: Icons.logout,
              expanded: false,
              text: 'Déconnexion',
              subTitle: '',
              isSelected: selectedIndex == 7,
              onTap: () async {
                setState(() {
                  selectedIndex = 7;
                });
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.clear();
                await pref.remove('token');
                // Then close the drawer
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => LoginScreen()),
                    (route) => false);
              }),
          Divider(),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required String subTitle,
      required GestureTapCallback onTap,
      required bool isSelected,
      required bool expanded}) {
    return Ink(
      color: Colors.transparent,
      child: expanded == true
          ? ExpansionTile(
              title: Text(text),
              leading: Icon(icon), //add icon
              childrenPadding: EdgeInsets.only(left: 60), //children padding
              children: [
                ListTile(
                  selected: true,
                  hoverColor: Colors.white,
                  title: Row(
                    children: <Widget>[
                      Icon(
                        icon,
                        color: isSelected ? kSeconderyColor : Colors.grey[600],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Text(
                          subTitle,
                          style: TextStyle(
                              color: isSelected
                                  ? kSeconderyColor
                                  : Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  onTap: onTap,
                ),
              ],
            )
          : ListTile(
              selected: true,
              hoverColor: Colors.white,
              title: Row(
                children: <Widget>[
                  Icon(
                    icon,
                    color: isSelected ? kSeconderyColor : Colors.grey[600],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text(
                      text,
                      style: TextStyle(
                          color:
                              isSelected ? kSeconderyColor : Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              onTap: onTap,
            ),
    );
  }

  Widget _createHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: kSeconderyColor,
      ),
      accountName: Text(userData != null ? '${userData['firstname']}' : ''),
      accountEmail: Text(userData != null ? '${userData['email']}' : ''),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
            ? kSeconderyColor
            : Colors.white,
        child: const Icon(
          Icons.person,
          color: kSeconderyColor,
          size: 50,
        ),
      ),
    );
  }
}
