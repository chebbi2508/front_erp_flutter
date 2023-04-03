import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../components/background.dart';
import '../../models/api_services.dart';
import '../../services/api.dart';
import '../../services/auth_services.dart';
import '../../theme/colors.dart';
import '../planning/planning.dart';
 
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

    TextEditingController email = TextEditingController();
  bool _isHidden = true;
  TextEditingController password = TextEditingController();
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  loginPressed() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      ApiResponse apiResponse = ApiResponse();
      http.Response response =
          await AuthServices.login(email.text, password.text);
       Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        await localStorage.setString(
            'token', json.encode(responseMap['token']));
        localStorage.setString('user', json.encode(responseMap['user']));
        localStorage.setString('type', responseMap['user']["job"]);
        localStorage.setInt('userId', responseMap['user']["id"]);
        localStorage.setString(
            'fullName',
            responseMap['user']["firstname"] +
                ' ' +
                responseMap['user']["lastname"]);
        var userJson = localStorage.getString('user');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CalendarPage(),
            ));
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(backgroundColor: Colors.white,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
               child:  Image.asset('assets/logo.jpg',width: 150,),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                    controller: email,
                  decoration: InputDecoration(
                    labelText: "Email",
                   
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                        controller: password,
                    obscureText: _isHidden,
                  decoration: InputDecoration(
                    labelText: "Mot de passe",
                      suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                  ),
                 ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: RaisedButton(
                  onPressed: () {
                    loginPressed();},
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: new LinearGradient(
                        colors: [
                          kSeconderyColor,kBackgroundColor 
                        ]
                      )
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),

           
            ],
          ),
        ),
      ),
    );
  }
}