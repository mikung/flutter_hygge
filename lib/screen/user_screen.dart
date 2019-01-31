import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var users;
  bool isLoading = true;
  Future<Null> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.get('token');
    final response = await http.get('https://randomuser.me/api/?results=20');
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      setState(() {
        isLoading = false;
        users = jsonResponse['results'];
      });
    } else {
      print('Connect error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users List'),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: getUsers,
                child: ListView.builder(
                  itemBuilder: (context, int index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(users[index]['picture']['medium']),
                        ),
                        title: Text(
                          '${users[index]['name']['first']} ${users[index]['name']['last']}',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        subtitle: Text('${users[index]['email']}'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    );
                  },
                  itemCount: users != null ? users.length : 0,
                ),
              ));
  }
}
