import 'dart:convert';

import 'package:authapi/view/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinder_card/tinder_card.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

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

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString('token') == null) {
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
    return Scaffold(
      backgroundColor: Color.fromARGB(200, 40, 40, 40),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Auth API", style: TextStyle(color: Colors.white)),
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
        child: TinderSwapCard(
          demoProfiles: demoProfiles,
          myCallback: (decision) {},
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
                  accountName: Text(_user.isNotEmpty && _user.containsKey('name') ? _user['name'] : ''),
                  accountEmail: Text(_user.isNotEmpty && _user.containsKey('email') ? _user['email'] : ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.black54,
                    backgroundImage: ExactAssetImage('assets/IMG_7848.png'),
                  )
              ),
              ListTile(
                title: Text("Home", style: TextStyle(color: Colors.white70)),
                trailing: Icon(Icons.arrow_right),
                onTap: () {},
              ),
              ListTile(
                title: Text("About", style: TextStyle(color: Colors.white70)),
                trailing: Icon(Icons.arrow_right),
                onTap: () {},
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

class Profile {
  final List<String> photos;
  final String name;
  final String bio;

  Profile({this.photos, this.name, this.bio});
}

// This widget will be passed as Top Card's Widget.
final List<Profile> demoProfiles = [
  new Profile(
    photos: [
      "assets/IMG_7848.png",
      "assets/IMG_7848.png",
      "assets/IMG_7848.png",
      "assets/IMG_7848.png",
      "assets/IMG_7848.png",
      "assets/IMG_7848.png",
    ],
    name: "Aneesh G",
    bio: "This is the person you want",
  ),
  new Profile(
    photos: [
      "assets/IMG_7848.png",
      "assets/IMG_7848.png",
    ],
    name: "Amanda Tylor",
    bio: "You better swpe left",
  ),
  new Profile(
    photos: [
      "assets/IMG_7848.png",
      "assets/IMG_7848.png",
    ],
    name: "Godson Mathew",
    bio: "You better swpe left",
  ),
];
