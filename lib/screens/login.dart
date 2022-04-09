import 'dart:ui';
import 'package:appointmentapp/screens/appointments.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:appointmentapp/constants/Theme.dart';

//widgets
import 'package:appointmentapp/widgets/navbar.dart';
import 'package:appointmentapp/widgets/input.dart';
import 'package:appointmentapp/screens/home.dart';
import 'package:appointmentapp/screens/doctor.dart';
import 'package:appointmentapp/widgets/drawer.dart';

import 'package:appointmentapp/screens/register.dart';
import 'package:appointmentapp/api/api.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _autovaliodate = false;
  bool _isLoading = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration:
                  BoxDecoration(color: Color(0xFFFFFFFF)),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16.0, right: 16.0, bottom: 32),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.78,
                          color: Color(0xFFFFFFFF),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Center(
                                    child: Image.asset('assets/imgs/vhc.png',
                                      height: 250,
                                      width: 230,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                            placeholder: "Email",
                                            onChanged: (value) {},
                                            controller: emailController,
                                            prefixIcon:
                                                Icon(Icons.lock, size: 20)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                            placeholder: "Password",
                                            controller: passwordController,
                                            pass: true,
                                            prefixIcon:
                                                Icon(Icons.lock, size: 20)),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 0),
                                          child: InkWell(
                                            child: Text('Create an account',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        Register()),
                                              );
                                            },
                                          )),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        // Respond to button press

                                        loginForm();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(32.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 40.0,
                                            right: 40.0,
                                            top: 12,
                                            bottom: 12),
                                        child: Text("Login",
                                            style: TextStyle(fontSize: 14.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))),
                ),
              ]),
            )
          ],
        ));
  }

  void loginForm() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'password': passwordController.text,
      'email': emailController.text,
    };

    var res = await CallApi().postDataWithoutToken(data, 'auth/login/');
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      final r = await CallApi()
          .getDataWithoutToken('users/' + body['user']['pk'].toString());
      var b = json.decode(r.body);

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token'].toString());
      localStorage.setString('user', b.toString());

      localStorage.setString('id', body['user']['pk'].toString());
      if(b['patient_status'])
        {
          localStorage.setString('r', '2');
        }
      else if(b['doctor_status'])
      {
        localStorage.setString('r', '3');
      }
      else if(b['admin_status'])
      {
        localStorage.setString('r', '1');
      }

      if (b['doctor_status']) {
        Navigator.pushNamed(context, '/appointment');

      } else if (b['admin_status']) {
        Navigator.pushNamed(context, '/doctor');
      } else {
        Navigator.pushNamed(context, '/home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Credentials'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
