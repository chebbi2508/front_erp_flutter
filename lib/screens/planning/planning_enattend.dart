import 'dart:async';
import 'dart:convert';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pfe/screens/user/components/rounted_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../input_filed.dart';
import '../../models/planning.dart';
import '../../models/population.dart';
import '../../models/user.dart';
import '../../services/callapi.dart';



class PopulationEtatScreen extends StatefulWidget {
  
   PopulationEtatScreen({Key? key}) : super(key: key);

  @override
  State<PopulationEtatScreen> createState() => _PopulationEtatScreenState();
}

class _PopulationEtatScreenState extends State<PopulationEtatScreen> {
  List status = ['validé ', 'aprouvé' , 'refusé'];
  
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
  //getplannings
  List<Planning> tousplannings = [];
  
  getplannings() async {
    // String myUrl = "http://10.0.2.2:8000/api/getplannings";
    http.Response response = await CallApi().getData('getplannings');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      Iterable ll = jsondata;
          tousplannings = ll.map<Planning>((json) => Planning.fromJson(json)).toList();
      setState(() {
        tousplannings = tousplannings.where((tousplannings) => tousplannings.status == 'aprouvé').toList();
          if (userData['job'] == 'admin'){
              tousplannings = tousplannings.where((tousplannings) => tousplannings.user_id == userData['id']).toList();
         }
      });
    }
   
    print(tousplannings);

    return tousplannings;
  }
      List users = [];

  getusers() async {
    
    http.Response response = await CallApi().getData('getusers');
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      Iterable ll = jsondata;
    
        
        setState(() {
            users = ll.map<User>((json) => User.fromJson(json)).toList();
        });
      
        
       
    }
    print(users);
    return users;
  }
 


  

  @override
  void initState() {
    super.initState();
       _getUserInfo();
    getplannings().then(
      (tousplannings) {
        setState(() {
          tousplannings;
       
        });
      },
    );
     getusers().then(
      (users) {
        setState(() {
          users;
       
        });
      },
    );
   
  }
  String nameuser = '';
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: const Text("Plannings Etat"),
       ),
      body: 
      FutureBuilder(
        // future: getpopulation(),
        builder: (contect, snapshot) {
          if (tousplannings == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
           
            return ListView.builder(
              itemCount: tousplannings == null ? 0 : tousplannings.length,
              itemBuilder: (BuildContext context, int index) {
          
                  for(int k=0 ; k< users.length ; k++){
                         
                              List idactivites = users
          .where((users) =>
              users.id == tousplannings[index].user_id)
          .toList();
      nameuser = idactivites[0].firstname + ' ' + idactivites[0].lastname;
                      
                             } ;
                             print('name : $nameuser');
                return InkWell(
                  onTap: () async {
                    //print(tousplannings[index].name);
                    showModalBottomSheet(
                       context: context,
                       builder: (context) { 
                         return Container(
                            padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
            child :Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   DropDownField(
                                        //controller: ligneselected,
                                        hintText: "Status",
                                        enabled: true,
                                        controller: tousplannings[index].status.isEmpty ? TextEditingController()
                    : TextEditingController(text: tousplannings[index].status) ,
                                        items: status.cast<String>(),
                                        onValueChanged: (value) {
                                          tousplannings[index].status = value ;
                                        },
                                      ),
                RoundedButton(
              color: Colors.green,
              onPressed: () async {
               updatestatu(tousplannings[index].id , tousplannings[index].status);
               
              },
              title: 'Edit',
            ),
                ]));
                         
                       } ) ;
            
                    
                    
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 6.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                               Text(
                              tousplannings[index].code,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          
                            
                            ],),
                            Row(children: [
                          
                            Text(
                             ' ${tousplannings[index].start_time}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const  Text(
                             ' to ',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            Text(
                            ' ${tousplannings[index].end_time}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            ],),
                           
                            Text(
                              tousplannings[index].status,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              nameuser ,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Color.fromRGBO(78, 164, 207, 1),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                       
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

    
  updatestatu(id , _status) async{
    var data = {
      "status":_status,
      "user_id": userData['id'] ,
    };

    print(data);
    http.Response res = await CallApi().putData(data, 'updatestatus/$id');
    var body = jsonDecode(res.body);
    
    print(body);
    if (body['message']== "planning updated.") {
     ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
    backgroundColor: Colors.green,
    content:  Text("Success .. !"),
    duration:  Duration(seconds: 2), 
     
  ));
     Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PopulationEtatScreen(),
                            ),
                          ) ;
     
     }


   }




 


}
