import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hygge/screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hygge/api/api_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final database =
    FirebaseDatabase.instance.reference().child('users/1345679800000');

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController ctrlUsername = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiProvider apiProvider = ApiProvider();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _firebaseToken;
  String ttt;
  StreamSubscription<Event> _onAdd;
  StreamSubscription<Event> _onChange;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('on message $message');
      print('/n a : ' + message['notification']);
    }, onResume: (Map<String, dynamic> message) {
      print('on resume $message');
    }, onLaunch: (Map<String, dynamic> message) {
      print('on launch $message');
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting regised');
    });
    _firebaseMessaging.getToken().then((token) {
      print('token:' + token);
      _onAdd = database.onChildAdded.listen(_onNoteAdded);
      _onChange = database.onChildChanged.listen(_onNoteUpdated);

      setState(() {
        _firebaseToken = token;
      });
    });
//    getToken();
  }

  void _onNoteAdded(Event event) {
//    print(event.snapshot.value['data'].toString());
    print('aaa');
    if (event.snapshot.key == 'data') {
      print(event.snapshot.value);
      setState(() {
        ttt = event.snapshot.value;
      });
    }
  }

  void _onNoteUpdated(Event event) {
    print(event.snapshot.key);
    if (event.snapshot.key == 'data') {
      print(event.snapshot.value);
      setState(() {
        ttt = event.snapshot.value;
      });
    }
  }

  Future<Null> doLogin() async {
//    final response = await http.post('http://35.247.184.8:4000/login',
//        body: {'username': ctrlUsername.text, 'password': ctrlPassword.text});
    final response =
        await apiProvider.doLogin(ctrlUsername.text, ctrlPassword.text);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['ok']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', jsonResponse['token']);
        String token = jsonResponse['token'];
        print(token);
        final rs = await apiProvider.getProfile(token);
        print(rs.body);
        if (rs.statusCode == 200) {
          var jsonrs = json.decode(rs.body);
          print(jsonrs['rows'][0]['cid']);
          String cid = jsonrs['rows'][0]['cid'];
          String ptname = jsonrs['rows'][0]['ptname'];
          prefs.setString('cid', cid);
          prefs.setString('ptname', ptname);
          DatabaseReference databaseReference = FirebaseDatabase().reference();
          databaseReference.child('users/$cid/').set(
              {"displayname": ptname, "notificationTokens": _firebaseToken});
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          print('error');
        }
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
//  void initState() {
//    super.initState();
////    getToken();
//  }

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
                                'ลงชื่อเข้าใช้งาน' + ttt,
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
