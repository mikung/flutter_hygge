import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hygge/screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController ctrlUsername = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Null> doLogin() async {
    final response = await http.post('http://35.247.184.8:4000/login',
        body: {'username': ctrlUsername.text, 'password': ctrlPassword.text});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['ok']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', jsonResponse['token']);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        print('${jsonResponse['error']}');
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Row(
          children: <Widget>[
//            CircularProgressIndicator(),
            Text('${jsonResponse['error']}')
          ],
        )));
      }
    } else {
      print('Connection error!');
    }
  }

  bool isLogged = false;
  Future<Null> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.get('token');
    if (token != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
//    getToken();
  }

  checkLogin() {
    print(ctrlUsername.text);
    print(ctrlPassword.text);
    if (ctrlUsername.text == 'admin' && ctrlPassword.text == 'admin') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
//            color: Color(0xFFF05A4D),
              color: Colors.white),
          Center(
              child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 300.0,
                    height: 300.0,
                    image: AssetImage('assets/images/hg_mds_01_4.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: ctrlUsername,
//                            obscureText: true,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Supermarket',
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_circle),
                                labelText: 'Username',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
//                                    color: const Colors(0xFFF05A4D),
                                      width: 30.0,
                                    ))),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: ctrlPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.vpn_key),
                                labelText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(width: 30.0))),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(30.0),
                            shadowColor: Colors.lightBlueAccent.shade100,
                            elevation: 5.0,
                            child: MaterialButton(
                              onPressed: () => doLogin(),
                              minWidth: 290.0,
                              height: 55,
//                              color: Colors.lightBlueAccent,
                              child: Text(
                                'ลงชื่อเข้าใช้งาน',
                                style: TextStyle(
                                    color: Color(0xFFF05A4D),
                                    fontSize: 30.0,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.3),
                              ),
                            ),
                          ),
//                          Material(
//                            borderRadius:
//                                BorderRadius.all(Radius.circular(20.0)),
//                            shadowColor: Colors.redAccent.shade100,
//                            elevation: 5.0,
//                            child: MaterialButton(
//                              onPressed: () => doLogin(),
//                              minWidth: 290.0,
//                              height: 55.0,
//                              color: Colors.pink,
//                              child: Text(
//                                'ลงชื่อเข้าใช้งาน',
//                                style: TextStyle(
//                                    color: Colors.white,
//                                    fontSize: 30.0,
//                                    fontFamily: 'Kanit',
//                                    fontWeight: FontWeight.w300,
//                                    letterSpacing: 0.3),
//                              ),
//                            ),
//                          ),
                          FlatButton(
                            onPressed: () {},
                            child: Text(
                              'Register new user',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Kanit'),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
