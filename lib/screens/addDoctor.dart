import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:appointmentapp/constants/Theme.dart';

//widgets
import 'package:appointmentapp/widgets/navbar.dart';
import 'package:appointmentapp/widgets/input.dart';
import 'package:appointmentapp/screens/login.dart';
import 'package:appointmentapp/widgets/drawer.dart';
import 'package:appointmentapp/api/api.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddDoctor extends StatefulWidget {
  @override
  _AddDoctorState createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  bool _checkboxValue = false;
  final _formKey = GlobalKey<FormState>();
  bool _autovaliodate = false;
  bool _isLoading = false;

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController about = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          title: "Add Doctors",
          rightOptions: false,
        ),
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
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "First Name",
                                          onChanged: (value) {},
                                          controller: firstname,
                                          prefixIcon:
                                              Icon(Icons.school, size: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                            placeholder: "Last Name",
                                            onChanged: (value) {},
                                            controller: lastname,
                                            prefixIcon:
                                                Icon(Icons.email, size: 20)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                            placeholder: "Email",
                                            onChanged: (value) {},
                                            controller: email,
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
                                            placeholder: "Username",
                                            onChanged: (value) {},
                                            controller: username,
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
                                            pass: true,
                                            onChanged: (value) {},
                                            controller: password,
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
                                            placeholder: "Phone Number",
                                            onChanged: (value) {},
                                            controller: phone,
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
                                            placeholder: "Rating",
                                            onChanged: (value) {},
                                            controller: rate,
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
                                            placeholder: "About",
                                            onChanged: (value) {},
                                            controller: about,
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
                                            placeholder: "Address",
                                            onChanged: (value) {},
                                            controller: address,
                                            prefixIcon:
                                                Icon(Icons.lock, size: 20)),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        // Respond to button press
                                        addDoctorForm();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Add Doctor",
                                              style:
                                                  TextStyle(fontSize: 14.0))),
                                    ),
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/doctor');
                                      },
                                      child: Text(
                                        "Back",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  )
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

  void addDoctorForm() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      "username": username.text,
      "email": email.text,
      "first_name": firstname.text,
      "last_name": lastname.text,
      "password": password.text,
      "patient_status": false,
      "doctor_status": true,
      "admin_status": false,
      "profile": {
        "rating": rate.text,
        "phone": phone.text,
        "about": about.text,
        "address": address.text
      }
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await CallApi()
        .postDataWithToken(data, 'users/', prefs.getString('token'));
    var body = json.decode(res.body);

    if (res.statusCode == 201) {
      print(body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('New Doctor has been added in the system'),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacementNamed(context, '/doctor');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fill the form properly'),
        backgroundColor: Colors.redAccent,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
