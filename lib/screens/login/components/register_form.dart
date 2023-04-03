import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfe/components/rounded_button.dart';
import 'package:pfe/components/rounded_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api.dart';
import '../../../services/auth_services.dart';
import 'package:http/http.dart' as http; 

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
    TextEditingController firstname = TextEditingController();
    TextEditingController lastname = TextEditingController();
    TextEditingController job = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    

   createAccountPressed() async {
   
    print(email.text);
   
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.text);
    
    if (emailValid) {    
    
      http.Response response =
          await AuthServices.register(firstname.text,lastname.text,job.text, email.text ,password.text  );
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
      
      localStorage.setString('user', json.encode(responseMap['user']));
       var userJson = localStorage.getString('user'); 
        var user = json.decode(userJson!);
         errorSnackBar(context, 'contact your ceo ');
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }}
   else {
       errorSnackBar(context, 'Email invalid');
   }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 0.0 : 1.0,
      duration: widget.animationDuration * 5,
      child: Visibility(
        visible: !widget.isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: widget.size.width,
            height: widget.defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                 const SizedBox(height: 20),

                 const Text(
                    'Create account',
                    style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),

                 const SizedBox(height: 20),

                  RoundedInput(icon: Icons.person , hint: 'First name', controller: firstname, color:const Color.fromARGB(255, 248, 242, 242)),
                  RoundedInput(icon: Icons.person, hint: 'Last name', controller: lastname, color:const Color.fromARGB(255, 248, 242, 242)),
                  RoundedInput(icon: Icons.mail, hint: 'Email', controller: email,color: const Color.fromARGB(255, 248, 242, 242)),
                  RoundedInput(icon: Icons.password, hint: 'Password', controller: password,color: const Color.fromARGB(255, 248, 242, 242)),
                  RoundedInput(icon: Icons.local_activity, hint: 'Job', controller: job,color:const Color.fromARGB(255, 248, 242, 242)),
                  

                  const  SizedBox(height: 10),

                  RoundedButton(title: 'SIGN UP' , ontap:(){
                    createAccountPressed();
                  } ,),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}