import 'package:flutter/material.dart';
import 'package:hygge/screen/add_screen.dart';
import 'package:hygge/screen/home_screen.dart';
import 'package:hygge/screen/login_screen.dart';
import 'package:hygge/screen/page_one.dart';
import 'package:hygge/screen/user_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove Debug mode
      theme: ThemeData(
        fontFamily: 'Supermaket',
        scaffoldBackgroundColor: Color(0xFFF05A4D),
        primaryColor: Color(0xFFF05A4D),
//          accentColor: Colors.amber
      ),

      title: 'Hygge',
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/add': (BuildContext context) => AddScreen('Hello'),
        '/photo': (BuildContext context) => PageOne(),
        '/users': (BuildContext context) => UserScreen(),
      },
    );
  }
}
