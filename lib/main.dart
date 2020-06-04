import 'dart:convert';
import 'dart:io';

import 'package:authapi/update.dart';
import 'package:authapi/view/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

enum Actions { edit, delete }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Auth API",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
        accentColor: Colors.black12
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;
  Map _user = {};
  List _employees;
  String _token = '';
  String newValue;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  getEmployees() async {
    final response = await http.get(
      'http://192.168.43.139:3000/api/employees',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'},
    );
    final responseJson = json.decode(response.body.toString());
    _employees = responseJson['employees'];
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _token = sharedPreferences.getString('token');
    if(_token == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage()
        ),
        (Route<dynamic> route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    userData();
    getEmployees();
    return Scaffold(
      backgroundColor: Color.fromARGB(200, 40, 40, 40),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("All Employees", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()
                ),
                (Route<dynamic> route) => false
              );
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: _employees != null ? _employees.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black54,
                      backgroundImage: _employees[index]['profile'] != null ? NetworkImage(_employees[index]['profile']) : NetworkImage("https://flutter-flask.s3-ap-southeast-1.amazonaws.com/laravel/images/1589343836avatar_profile_user_music_headphones_shirt_cool-512.png"),
                    ),
                    contentPadding: EdgeInsets.all(10.0),
                    title: Text(_employees[index]['first_name']),
                    subtitle: Text(_employees[index]['email']),
                    trailing: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                        children: <Widget>[
                          PopupMenuButton(
                            onSelected: (value) {
                              if (value == Actions.edit) {
                                sharedPreferences.setString("token", _token);
                                sharedPreferences.setString("user", jsonEncode(_user));
                                sharedPreferences.setInt("id", _employees[index]['id']);
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => Update()
                                  ),
                                  (Route<dynamic> route) => false
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<Actions>>[
                              const PopupMenuItem<Actions>(
                                value: Actions.edit,
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<Actions>(
                                value: Actions.delete,
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            );
          }
        )
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black87,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                  ),
                  accountName: Text(_user.isNotEmpty && _user.containsKey('first_name') ? _user['first_name'] : ''),
                  accountEmail: Text(_user.isNotEmpty && _user.containsKey('email') ? _user['email'] : ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.black54,
                    backgroundImage: _user.isNotEmpty && _user.containsKey('profile') ? NetworkImage(_user['profile']) : NetworkImage("https://flutter-flask.s3-ap-southeast-1.amazonaws.com/laravel/images/1589343836avatar_profile_user_music_headphones_shirt_cool-512.png"),
                  )
              ),
              ListTile(
                title: Text("Users", style: TextStyle(color: Colors.white70)),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void userData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.get('user') != null) {
      setState(() {
        _user = json.decode(sharedPreferences.get('user'));
      });
    }
  }
}
