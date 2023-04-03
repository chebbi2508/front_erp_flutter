
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pfe/screens/planning/planning.dart';
import 'package:pfe/screens/pointage/add_pointing_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
 

import '../screens/login2/login.dart';
import '../screens/planning/add_task_user.dart';



class MydrawerUser extends StatefulWidget {
  @override
  State<MydrawerUser> createState() => _MydrawerUserState();
}

class _MydrawerUserState extends State<MydrawerUser> {
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

   @override
  void initState() {
    super.initState();

    _getUserInfo();
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
                  accountName: Text(userData!= null ? '${userData['firstname']}' : ''),
                  accountEmail: Text(userData!= null ? '${userData['email']}' : ''),
                  currentAccountPicture:
                      const CircleAvatar(child: Icon(Icons.person),),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(19, 124, 163, 64),
                  ),
                ),
                CustomListTile(Icons.home, ()=>{
                    Navigator.push(
             context,
             MaterialPageRoute(
               builder: (BuildContext context) =>  CalendarPage(),
             ))
  }, 'Accueil'),    
 
  CustomListTile(Icons.add_task, ()=>{
                  
               Navigator.push(
             context,
             MaterialPageRoute(
               builder: (BuildContext context) =>  AddTaskUserPage(),
             ))
          
  }, 'ajouter planification'),
    CustomListTile(Icons.add_task, ()=>{
                  
               Navigator.push(
             context,
             MaterialPageRoute(
               builder: (BuildContext context) => AddPointingUserPage (),
             ))
          
  }, 'ajouter pointage'),
    CustomListTile(Icons.logout, ()async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    await pref.clear();
                    await pref.remove('token');
                    // Then close the drawer
                     Navigator.push(
             context,
             MaterialPageRoute(
               builder: (BuildContext context) =>  LoginScreen(),
             ));
                    
                  }, 'Déconnexion'),
              ],
            )));
  }
}
class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function()  onTap;
  CustomListTile(this.icon,this.onTap,this.text);
  @override 
  Widget build(BuildContext context) {
    // TODO: implement build 
    return Padding(padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
    child: Container(
      decoration:  BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade400))
      ),
     
    child: InkWell( 
      splashColor : Color.fromRGBO(19, 124, 163, 64), 
      onTap: onTap , 
      child:  Container(
        height: 60  ,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon),
                Padding(
                 padding: const EdgeInsets.all(8.0),
                 child:  Text(text,style: TextStyle(
                  fontSize: 16.0
                ),),
                ),
              ],
            ),
            Icon(Icons.arrow_right),
          ],
        ),
      ),
    ),
    ),);
  }





}