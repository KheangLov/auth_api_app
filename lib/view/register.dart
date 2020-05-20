import 'dart:convert';
import 'dart:io';

import 'package:authapi/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showScaffold(String message, String type) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: type == 'error' ? Colors.red : Colors.green,
      )
    );
  }

  String _valGender;
  List _listGender = ["Male", "Female"];
  String _date = "Not set";
  File _image;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            dateDrop(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  signUp(Map data) async {
    print(data);
    var response = await http.post(
      "http://192.168.1.6:3000/api/auth/register",
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'}
    );
    var resData = json.decode(response.body);
    print(resData);
    if(resData.containsKey('status') && resData['status'] == 400) {
      setState(() {
        _isLoading = false;
      });
      _showScaffold(resData['message'], 'error');
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
                  _showScaffold("Wrong password confirmation!", 'error');
                  return false;
                }
                setState(() {
                  _isLoading = true;
                });
                Map data = {
                  'email': emailController.text,
                  'password': passwordController.text,
                  'first_name': fnameController.text,
                  'last_name': lnameController.text,
                  'gender': _valGender,
                  'dob': _date,
                };
                signUp(data);
                return false;
              },
              elevation: 0.0,
              color: Colors.black87,
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
              color: Colors.black87,
              child: Text("GO TO LOGIN", style: TextStyle(color: Colors.white70)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              padding: EdgeInsets.only(top: 15, bottom: 15),
            ),
          )
        ],
      ),
    );
  }

  final TextEditingController fnameController = new TextEditingController();
  final TextEditingController lnameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordConfirmController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 90,
            backgroundColor: Colors.white70,
            child: CircleAvatar(
              radius: 85,
              backgroundColor: Colors.black87,
              backgroundImage: _image != null ? ExactAssetImage(_image.path)  : NetworkImage("https://flutter-flask.s3-ap-southeast-1.amazonaws.com/laravel/images/1589343836avatar_profile_user_music_headphones_shirt_cool-512.png"),
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
            controller: fnameController,
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
            controller: lnameController,
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

  Container dateDrop() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Column(
        children: <Widget>[
          DropdownButton(
            isExpanded: true,
            hint: Text("Select The Gender", style: TextStyle(color: Colors.white70)),
            value: _valGender,
            items: _listGender.map((value) {
              return DropdownMenuItem(
                child: Text(value, style: TextStyle(color: Colors.black87)),
                value: value,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _valGender = value;
              });
            },
          ),
          RaisedButton(
            elevation: 4.0,
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                theme: DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true,
                maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                  String theDate = '${date.year}-${date.month}-${date.day}';
                  setState(() {
                    _date = theDate;
                  });
                },
                currentTime: DateTime.now(), locale: LocaleType.en
              );
            },
            child: Container(
              color: null,
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              size: 18.0,
                              color: Colors.white70,
                            ),
                            Text(
                              " $_date",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Icon(
                      Icons.arrow_drop_down
                  )
                ],
              ),
            ),
            color: Color.fromARGB(200, 40, 40, 40),
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
