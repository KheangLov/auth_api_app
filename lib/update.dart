import 'dart:convert';
import 'dart:io';

import 'package:authapi/main.dart';
import 'package:authapi/view/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

enum Actions { edit, delete }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Auth API",
      debugShowCheckedModeBanner: false,
      home: Update(),
      theme: ThemeData(
          accentColor: Colors.black12
      ),
    );
  }
}

class Update extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Update> {
  SharedPreferences sharedPreferences;
  Map _user = {};
  Map _employee;
  String _token = '';
  String newValue;
  File _image;
  var _id;
  TextEditingController fNameController = new TextEditingController();
  TextEditingController lNameController = new TextEditingController();

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _id = sharedPreferences.getInt('id');
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

  getEmp() async {
    final response = await http.get(
      'http://192.168.1.6:3000/api/employee/$_id',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'},
    );
    final responseJson = json.decode(response.body.toString());
    _employee = responseJson['employee'];
    fNameController.text = _employee['first_name'];
    lNameController.text = _employee['last_name'];
  }

  @override
  Widget build(BuildContext context) {
    userData();
    getEmp();
    return Scaffold(
      backgroundColor: Color.fromARGB(200, 40, 40, 40),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Edit Employee", style: TextStyle(color: Colors.white)),
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
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 90,
              backgroundColor: Colors.white70,
              child: CircleAvatar(
                radius: 85,
                backgroundColor: Colors.black87,
                backgroundImage: _image != null ? NetworkImage(_image.path) : (_employee['profile'] != null ? NetworkImage(_employee['profile']) : NetworkImage('https://flutter-flask.s3-ap-southeast-1.amazonaws.com/laravel/images/1589343836avatar_profile_user_music_headphones_shirt_cool-512.png')),
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent, // button color
                    child: InkWell(
                      splashColor: Colors.white70, // inkwell color
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: RaisedButton(
                          color: Color.fromARGB(0, 0, 0, 0),
                          onPressed: getImage,
                          child: Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: fNameController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.white70),
                hintText: "Firstname",
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: lNameController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.white70),
                hintText: "Lastname",
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(height: 30.0),
          ],
        ),
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
                title: Text("Employees", style: TextStyle(color: Colors.white70)),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  sharedPreferences.setString("token", _token);
                  sharedPreferences.setString("user", jsonEncode(_user));
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => MainPage()
                    ),
                    (Route<dynamic> route) => false
                  );
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
