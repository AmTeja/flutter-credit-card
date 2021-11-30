import 'dart:convert';

import 'package:credit_card_project/animated_route.dart';
import 'package:credit_card_project/credit_cards_page.dart';
import 'package:credit_card_project/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {

  bool login = false;
  bool loading = false;
  bool error = false;
  String errorText = "";

  AnimatedRoute ar = AnimatedRoute();

  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  TextEditingController usernameTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: GestureDetector(
        onTap: () { FocusScope.of(context).unfocus();},
        child: Scaffold(
          backgroundColor: Color(0xff2c2c2c),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: AlignmentDirectional.topCenter,
                    child: Lottie.asset("assets/lotties/register.json", repeat: true)),
                Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 3,
                      child: Container(
                        child: login ? _getLogin() : _getRegister(),
                      )),
                  Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              if(loading) return;
                              FocusScope.of(context).unfocus();
                              error = false;
                              loading = true;
                              setState(() {});
                              if(login){
                                if(loginKey.currentState.validate()){
                                  await _doLogin();
                                }
                              }else{
                                if(registerKey.currentState.validate()){
                                  await _doRegister();
                                }
                              }
                              loading = false;
                              setState(() {
                              });
                            },
                            color: Color(0xFFFF63B1),
                            shape: StadiumBorder(),
                            minWidth: 250,
                            child: loading ?
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: CircularProgressIndicator(),) : Text(login ? "Login" : "Register", style: TextStyle(color: Colors.white, fontSize: 22),),
                          ),
                          SizedBox(height: 10,),
                          MaterialButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                error = false;
                                usernameTEC.text = "";
                                emailTEC.text = "";
                                passwordTEC.text = "";
                                setState(() {
                                  login = !login;
                                });
                              },
                              minWidth: 100.0,
                              child: Text(login ? "Register?" : "Login?", style: TextStyle(color: Colors.white, fontSize: 18),),
                          ),
                          error ? Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.amberAccent,
                              alignment: Alignment.center,
                              child: Text(errorText, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18),),
                            ),
                          ) : Container()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLogin()
  {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Form(
        key: loginKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                child: Text("Login", style: TextStyle(color: Color(0xFFFF63b1), fontSize: 32),)),
            SizedBox(height: 50,),
            TextFormField(
              controller: emailTEC,
              validator: (val) {
                if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                  return "Invalid email format";
                }
                return null;
                },
              style: TextStyle(color: Colors.white),
              decoration: getInputDecoration("Email"),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: passwordTEC,
              validator: (val) {
                if(val.isEmpty) return "Password cannot be empty";
                if(val.length > 16 || val.length < 8) return "Password must be between length of 8 and 16";
                return null;
              },
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: getInputDecoration("Password"),
            )
          ],
        ),
      ),
    );
  }

  Widget _getRegister()
  {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.center,
      child: Form(
        key: registerKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Register", style: TextStyle(color: Color(0xffff63b1), fontSize: 32),)),
            TextFormField(
              controller: usernameTEC,
              validator: (val) {
                if(val.isEmpty) return "Username cannot be empty";
                if(val.length > 16 || val.length < 8) return "Username must be between length of 8 and 16";
                return null;
              },
              style: TextStyle(color: Colors.white),
              decoration: getInputDecoration("Username"),
              ),
            SizedBox(height: 20,),
            TextFormField(
              controller: emailTEC ,
              validator: (val) {
                if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                  return "Invalid email format";
                }
                return null;
              },
              style: TextStyle(color: Colors.white),
              decoration: getInputDecoration("Email")
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: passwordTEC,
              validator: (val) {
                if(val.isEmpty) return "Password cannot be empty";
                if(val.length > 16 || val.length < 8) return "Password must be between length of 8 and 16";
                return null;
              },
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: getInputDecoration("Password"),
            ),
          ],
        ),
      ),
    );
  }

  getInputDecoration(String hint) {
    return InputDecoration(
        fillColor: Color(0xFF2c2c2c),
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(
            color: Colors.white,
          )
        ),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
    ) );
  }


  _doLogin() async {

    var url = Uri.parse("https://flutter-assignment-api.herokuapp.com/v1/auth/login");
    Map data = {
      "email" : emailTEC.text,
      "password" : passwordTEC.text
    };
    var body = json.encode(data);
    var response = await http.post(
      url,
      headers: {"accept": "application/json", "content-type": "application/json" },
      encoding: Encoding.getByName("utf-8"),
      body: body,
    );
    if(response.statusCode == 200){
      User user = User.fromJson(json.decode(response.body));
      Navigator.pushReplacement(context, ar.createRoute(CreditCardsPage(user: user,), false));
    }else {
      errorText = json.decode(response.body)["message"];
      setState(() {
        error = true;
      });
    }
  }

  _doRegister() async {
    var url = Uri.parse("https://flutter-assignment-api.herokuapp.com/v1/auth/register");
    Map data = {
      'name': usernameTEC.text,
      'email' : emailTEC.text,
      'password' : passwordTEC.text};
    var body = json.encode(data);
    var response = await http.post(
      url,
      headers: {"accept": "application/json", "content-type": "application/json" },
      encoding: Encoding.getByName("utf-8"),
      body: body,
    );
    if(response.statusCode == 201){
    }else {
      errorText = json.decode(response.body)["message"];
      setState(() {
        error = true;
      });
    }
  }
}
