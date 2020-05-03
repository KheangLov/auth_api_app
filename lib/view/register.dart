import 'dart:convert';

import 'package:authapi/view/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';



class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  signUp(String email, pass, name) async {
    Map data = {
      'email': email,
      'password': pass,
      'name': name
    };
    var response = await http.post(
        "http://192.168.1.12:5000/api/auth/register",
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'}
    );
    var resData = json.decode(response.body);
    print(resData);
    if(resData.containsKey('status') && resData['status'] == 400) {
      setState(() {
        _isLoading = false;
      });
      _showScaffold(resData['message']);
    }
    else {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage()
        ),
        (Route<dynamic> route) => false
      );
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
                if (passwordController.text != passwordConfirmController.text) {
                  _showScaffold("Wrong password confirmation!");
                  return false;
                }
                setState(() {
                  _isLoading = true;
                });
                signUp(emailController.text, passwordController.text, nameController.text);
                return false;
              },
              elevation: 0.0,
              color: Colors.purple,
              child: Text("REGISTER", style: TextStyle(color: Colors.white70)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              padding: EdgeInsets.only(top: 15, bottom: 15),
            ),
          ),
          SizedBox(height: 15.0),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()
                    ),
                    (Route<dynamic> route) => false
                );
              },
              color: Colors.greenAccent,
              child: Text("GO TO LOGIN", style: TextStyle(color: Colors.white70)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              padding: EdgeInsets.only(top: 15, bottom: 15),
            ),
          )
        ],
      ),
    );
  }

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordConfirmController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: nameController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.white70),
              hintText: "Name",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordConfirmController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.white70),
              hintText: "Confirm Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Center(
        child: Text("REGISTER",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 40.0,
            fontWeight: FontWeight.bold
          )
        ),
      )
    );
  }
}
