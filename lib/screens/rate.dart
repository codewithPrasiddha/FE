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

Future<List> fetchData() async {
  return ["1", "2", "3", "4", "5"];
  // final response = await CallApi().getData('hospitals');
  // var body = json.decode(response.body);

  // if (response.statusCode == 200) {
  //   List jsonResponse = body['payload']['data'];
  //   return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  // } else {
  //   throw Exception('Unexpected error occured!');
  // }
}

class Rate extends StatefulWidget {
  String doctor;
  Rate({this.doctor});
  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> {
  bool _checkboxValue = false;
  final _formKey = GlobalKey<FormState>();
  bool _autovaliodate = false;
  bool _isLoading = false;
  String _currentUser;
  Future<List> futureDate;
  @override
  void init() {}

  TextEditingController rate = TextEditingController();
  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          title: "Rate Doctor",
          rightOptions: false,
        ),
        drawer: NowDrawer(
          currentPage: "Rating",
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
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 0),
                                          child: Text('Rate'),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      SizedBox(height: 8.0),
                                      SizedBox(height: 8.0),
                                      Center(
                                        child: RaisedButton(
                                          textColor: NowUIColors.white,
                                          color: NowUIColors.primary,
                                          onPressed: () async {
                                            var data = {
                                              'rating': 1,
                                              'doctor': widget.doctor,
                                            };
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            var res = await CallApi()
                                                .postDataWithToken(
                                                    data,
                                                    'appointment/ratings-add/',
                                                    prefs.getString('token'));
                                            var body = json.decode(res.body);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text('Rating Completed'),
                                              backgroundColor: Colors.green,
                                            ));
                                            Navigator.pushReplacementNamed(
                                                context, '/appointment');
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
                                            child: Row(
                                                children: [Icon(Icons.star)]),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Center(
                                        child: RaisedButton(
                                          textColor: NowUIColors.white,
                                          color: NowUIColors.primary,
                                          onPressed: () async {
                                            var data = {
                                              'rating': 2,
                                              'doctor': widget.doctor,
                                            };
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            var res = await CallApi()
                                                .postDataWithToken(
                                                    data,
                                                    'appointment/ratings-add/',
                                                    prefs.getString('token'));
                                            var body = json.decode(res.body);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text('Rating Completed'),
                                              backgroundColor: Colors.green,
                                            ));
                                            Navigator.pushReplacementNamed(
                                                context, '/appointment');
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
                                            child: Row(children: [
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                            ]),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Center(
                                        child: RaisedButton(
                                          textColor: NowUIColors.white,
                                          color: NowUIColors.primary,
                                          onPressed: () async {
                                            var data = {
                                              'rating': 3,
                                              'doctor': widget.doctor,
                                            };
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            var res = await CallApi()
                                                .postDataWithToken(
                                                    data,
                                                    'appointment/ratings-add/',
                                                    prefs.getString('token'));
                                            var body = json.decode(res.body);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text('Rating Completed'),
                                              backgroundColor: Colors.green,
                                            ));
                                            Navigator.pushReplacementNamed(
                                                context, '/appointment');
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
                                            child: Row(children: [
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                            ]),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      RaisedButton(
                                        textColor: NowUIColors.white,
                                        color: NowUIColors.primary,
                                        onPressed: () async {
                                          var data = {
                                            'rating': 4,
                                            'doctor': widget.doctor,
                                          };
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var res = await CallApi()
                                              .postDataWithToken(
                                                  data,
                                                  'appointment/ratings-add/',
                                                  prefs.getString('token'));
                                          var body = json.decode(res.body);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Rating Completed'),
                                            backgroundColor: Colors.green,
                                          ));
                                          Navigator.pushReplacementNamed(
                                              context, '/appointment');
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
                                          child: Row(children: [
                                            Icon(Icons.star),
                                            Icon(Icons.star),
                                            Icon(Icons.star),
                                            Icon(Icons.star),
                                          ]),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Center(
                                        child: RaisedButton(
                                          textColor: NowUIColors.white,
                                          color: NowUIColors.primary,
                                          onPressed: () async {
                                            var data = {
                                              'rating': 5,
                                              'doctor': widget.doctor,
                                            };
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            var res = await CallApi()
                                                .postDataWithToken(
                                                    data,
                                                    'appointment/ratings-add/',
                                                    prefs.getString('token'));
                                            var body = json.decode(res.body);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text('Rating Completed'),
                                              backgroundColor: Colors.green,
                                            ));
                                            Navigator.pushReplacementNamed(
                                                context, '/appointment');
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
                                            child: Row(children: [
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/appointment');
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
      "rating": rate.value
//      "doctor":widget.doctor
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await CallApi()
        .postDataWithToken(data, 'users/', prefs.getString('token'));
    var body = json.decode(res.body);

    if (res.statusCode == 201) {
      print(body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Rating Completed'),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacementNamed(context, '/appointment');
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
