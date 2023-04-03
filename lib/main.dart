import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfe/screens/user/user.dart';
import 'loading.dart';
import 'theme/colors.dart';

DateTime get _now => DateTime.now();

void main() {
  runApp(App()); 
  
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
     MaterialApp(
        // title: 'Flutter Calendar Page Demo',
        debugShowCheckedModeBanner: false,
       // theme: ThemeData.light(),
         theme: ThemeData(
           appBarTheme: AppBarTheme(color: kSeconderyColor ),
         primaryColor: kSeconderyColor,
   ),
        scrollBehavior: ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          }
          ),
      home: Loading(),
       routes: <String, WidgetBuilder> {
      "/userscreen": (BuildContext context) => new UsersScreen()
    }
    );
  }
}

