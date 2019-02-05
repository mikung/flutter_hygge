import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:hygge/screen/page_one.dart';
import 'package:hygge/screen/page_two.dart';
import 'package:hygge/screen/page_three.dart';
import 'package:hygge/screen/add_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hygge/api/api_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextStyle myStyleTitle = TextStyle(
      fontFamily: 'Supermarket', fontSize: 30.0, fontWeight: FontWeight.bold);
  TextStyle myStyleText = TextStyle(
      fontFamily: 'Supermarket', fontSize: 16.0, fontWeight: FontWeight.bold);

  int _currentIndex = 0;
  List pages = [PageOne(), PageTwo(), PageThree()];
  bool hasImage = false;
  var profile;
  String token;
  String cid;
  String ptname;

  ApiProvider apiProvider = ApiProvider();

  Future<Null> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.get('token');
      cid = prefs.get('cid');
      ptname = prefs.get('ptname');
    });
//    final response = await apiProvider.getProfile(token);
//    if (response.statusCode == 200) {
//      var jsonResponse = json.decode(response.body);
//      print(jsonResponse);
//
//      if (jsonResponse['ok']) {
//        print(jsonResponse['rows']);
//
//        setState(() {
//          profile = jsonResponse['rows'][0];
//        });
//      } else {
//        print('token : $token');
//        print(jsonResponse['error']);
//      }
//    } else {
//      print('Connect Error');
//    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = new AppBar(
      /*title: Text(
        'Hygge',
        style: myStyleTitle,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () => Navigator.of(context).pushNamed('/add'),
        )
      ],*/
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/hgc_003.png',
            height: 30,
          )
        ],
      ),
    );

    Widget floatingAction = FloatingActionButton(
      onPressed: () async {
        var response = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddScreen('Hello Flutter')));
        if (response != null) {
          print(response);
          print(response['name'] ?? '-');
        }
      },
      child: Icon(Icons.add),
    );
    Widget bottomNavBar = BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'หน้าหลัก',
              style: myStyleText,
            )),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(
              'ข้อมูลส่วนตัว',
              style: myStyleText,
            )),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text(
              'ตั้งค่า',
              style: myStyleText,
            )),
      ],
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
    Widget drawer = Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
//          DrawerHeader(
//            child: Text('Drawer Header'),
//            decoration: BoxDecoration(
//              color: Color(0xFFF05A4D),
//            ),
//          ),

          UserAccountsDrawerHeader(
            accountName: Text(cid),
            accountEmail: Text(ptname),
            currentAccountPicture: hasImage
                ? CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Text(
                      'MI',
                      style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    ),
                    /*backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/med/men/87.jpg'),*/
                  )
                : CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/hg_mds_01_4.png'),
                    backgroundColor: Colors.white,
                  ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('หน้าหลัก'),
            subtitle: Text(
              'หน้าเมนูใช้งานหลัก',
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('ข้อมูลผู้ใช้'),
            subtitle: Text(
              'ข้อมูลผู้ใช้',
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('ผู้ใช้งานระบบ'),
            subtitle: Text(
              'ข้อมูลผู้ใช้งานในระบบ',
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/users');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('ตั้งค่าการใช้งาน'),
            subtitle: Text(
              'ตั้งค่าการใช้งาน',
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          Divider(),
          ListTile(
            title: Text('ออกจากแอพพลิเคชั้น'),
            subtitle: Text(
              'ตั้งค่าการใช้งาน',
            ),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              // Update the state of the app
              exit(0);
              // ...
            },
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: pages[_currentIndex],
      drawer: drawer,
//      floatingActionButton: floatingAction,
      bottomNavigationBar: bottomNavBar,
    );
  }
}
