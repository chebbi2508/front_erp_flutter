import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:pfe/screens/user/components/rounted_btn.dart';

import '../../../services/callapi.dart';
import 'add_user.dart';


class UserDataScreen extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String email;
  final String job;
  final String status;
  final String popu;
  final int iduser;
  final List popus;
  final List jobs;
  final int id;

  UserDataScreen(
      {required this.firstname,
      required this.lastname,
      required this.email,
      required this.job,
      required this.popu,
      required this.popus,
      required this.iduser,
      required this.status,
      required this.jobs,
      required this.id});

  Future<String?> _showAlertDialog(
      BuildContext context, String userName, int id) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Supprimer !',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Êtes-vous sûr de vouloir supprimer utilisateur : $userName ?'),
                const Text('Appuyez sur oui pour supprimer!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Non'),
              onPressed: () {
                Navigator.of(context).pop("non");
              },
            ),
            TextButton(
              child: const Text('Oui'),
              onPressed: () async {
               Navigator.of(context).pop("Oui");
             await delete(id);
              },
            ),
          ],
        );
      },
    );
  }

 
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              firstname,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30.0,
                color: Color(0xff383838),
                fontWeight: FontWeight.w500,
              ),
            ),
               const SizedBox(
              height: 20.0,
            ),
             Text(
              lastname,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30.0,
                color: Color(0xff383838),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'E-mail: $email',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                color: Color(0xff066163),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Travail: $job',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                color: Color(0xff066163),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Statut:  ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xff066163),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: (status == 'active') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
             const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Population:  ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xff066163),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  popu,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            RoundedButton(
              color: Colors.red,
              onPressed: () async {
                print('Bouton Supprimer cliquer');
                final result = await _showAlertDialog(context, firstname, id);
                Navigator.pop(context, result);
              },
              title: "Supprimer l'utilisateur",
            ),
            RoundedButton(
              color: Colors.green,
              onPressed: () async {
                print('Bouton Modifier cliquer');
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddModifyUserScreen(
                      firstname: firstname,
                      lastname: lastname,
                      email: email,
                      job: job,
                      status: status,
                      population: popu,
                      populations: popus,
                      jobs: jobs,
                      id: id, iduser: iduser,
                    ),
                  ),
                );
                Navigator.pop(context, result);
              },
              title: 'Modifier Utilisateur',
            ),
          ],
        ),
      ),
    );
  }

   delete(int id)async{ 
    
    print(id);
    
    http.Response response =await CallApi().deleteData('deleteuser/$id');
     Map responseMap = jsonDecode(response.body);
     print(responseMap);
    if (response.statusCode == 200) {
     
     print(responseMap);
    }else {
     print(responseMap);
      }
} 
}
