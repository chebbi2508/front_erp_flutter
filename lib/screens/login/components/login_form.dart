import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfe/components/rounded_button.dart';
import 'package:pfe/components/rounded_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/input_container.dart';
import '../../../constants.dart';
import '../../../models/api_services.dart';
import '../../../services/api.dart';
import '../../../services/auth_services.dart';
import '../../../theme/colors.dart';
import '../../planning/planning.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
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
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController email = TextEditingController();
  bool _isHidden = true;
  TextEditingController password = TextEditingController();

  loginPressed() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      ApiResponse apiResponse = ApiResponse();
      http.Response response =
          await AuthServices.login(email.text, password.text);
      print(email.text);
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
    return AnimatedOpacity(
      opacity: widget.isLogin ? 1.0 : 0.0,
      duration: widget.animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: widget.size.width,
          height: widget.defaultLoginSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const SizedBox(height: 50),
                Image.asset('assets/logo.jpg',width: 200,),
                const SizedBox(height: 2),
                RoundedInput(
                  color: kSeconderyColor,
                  icon: Icons.mail,
                  hint: 'Email',
                  controller: email,
                ),
                // RoundedPassInput(icon: Icons.password, hint: 'Password', controller: password, isHidden: _isHidden, ontap: () {  _togglePasswordView();},),

                InputContainer(
                  child: TextFormField(
                    cursorColor: kSeconderyColor,
                    controller: password,
                    obscureText: _isHidden,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        icon:const Icon(Icons.password, color: kSeconderyColor),
                        hintText: 'Password',
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                        border: InputBorder.none),
                  ),
                ),
               const SizedBox(height: 10),
                RoundedButton(
                  title: 'LOGIN',
                  ontap: () {
                    loginPressed();
                  },
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
