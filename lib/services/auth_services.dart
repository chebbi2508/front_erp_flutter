import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:pfe/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_services.dart';
import '../models/user.dart';

class AuthServices {
  static Future<http.Response> register(
      String firstname,String lastname,String job ,String email,  String password) async {
    Map data = {
      "firstname": firstname,
      "lastname": lastname,
      "job": job,
      "email": email,
      "password": password ,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> login(String email , String password) async {
    Map data = {
      "email": email ,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    print(token);
    // String cc = '45|TwCgTkPKZUMgw5cBmN2dfPlZJiNu2ZhKBJ2iEUs1' ;
    // print(cc);
    final response = await http.get(Uri.parse(userUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
       print(response.body);
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
  // get token
Future<String> getToken() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var _token = localStorage.getString('token') ;
      var user_token  ;
      if(_token == null){
        user_token = '' ;
      }else{
       user_token = json.decode(_token) ;
      }
    return user_token  ;
}

