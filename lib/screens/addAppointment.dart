import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
//import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:appointmentapp/constants/Theme.dart';

//widgets
import 'package:appointmentapp/widgets/navbar.dart';
import 'package:appointmentapp/widgets/input.dart';

import 'package:appointmentapp/widgets/drawer.dart';
import 'package:appointmentapp/api/api.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

// import 'package:khalti_core/khalti_core.dart';
// import 'package:khalti_core_example/khalti_http_client.dart';
Future<List<Data>> fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response =
      await CallApi().getGet('appointment', prefs.getString('token'));
  var body = json.decode(response.body);
  print(body);

  if (response.statusCode == 200) {
    List jsonResponse = body;

    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class AddAppointment extends StatefulWidget {
  String index;
  AddAppointment({this.index});
  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class Data {
  final String id;

  final String date;
  final String time;

  Data({
    this.id,
    this.date,
    this.time,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      date: json['date'],
      time: json['time'],
    );
  }
}

class _AddAppointmentState extends State<AddAppointment> {
  bool _isLoading = false;
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  String doctor_id;
  Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    doctor_id = widget.index;
    print(doctor_id);
    futureData = fetchData();
  }

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  TextEditingController date = TextEditingController();
  bool status = false;

  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          transparent: true,
          title: "",
          reverseTextcolor: true,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFFFFFFFF),
        drawer: NowDrawer(currentPage: "Appointment"),
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
                                  Text('Add Doctors',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
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
                                        child: Center(
                                            child: TextField(
                                          readOnly: true,
                                          controller: date,
                                          decoration:
                                              InputDecoration(hintText: 'Date'),
                                          onTap: () async {
                                            var dates = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                            date.text = dates
                                                .toString()
                                                .substring(0, 10);
                                          },
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: _selectTime,
                                                child: Text('Time'),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                '${_time.format(context)}\n',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(child: Text("Online/Physical")),
                                      Center(
                                        child: Switch(
                                          value: status,
                                          onChanged: (value) {
                                            setState(() {
                                              status = value;
                                              print(status);
                                            });
                                          },
                                          activeTrackColor:
                                              Colors.lightGreenAccent,
                                          activeColor: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        appointmentForm();
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
                                          child: Text("Add",
                                              style:
                                                  TextStyle(fontSize: 14.0))),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: InkWell(
                                          child: Text("Back"),
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/home');
                                          },
                                        )),
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

  void appointmentForm() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id');

    print(id);

    String formatTimeOfDay(TimeOfDay tod) {
      final now = new DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      final format = DateFormat.jm();
      return format.format(dt);
    }

    String tame = formatTimeOfDay(_time);

    var data = {
      'doctor_id': doctor_id,
      'client_id': id,
      'date': date.text,
      'time': tame,
      'status': status
    };
    print(data);
    // List app = await fetchData();

    // for (var i = 0; i < app.length; i++) {
    // if (app[i]['doctor_id'] == doctor_id) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Appointment Already booked'),
    //     backgroundColor: Colors.redAccent,
    //   ));
    // } else {
//    KhaltiScope.of(context).pay(
//      config: PaymentConfig(
//        amount: 1000,
//        productIdentity: 'dells-sssssg5-g5510-2021',
//        productName: 'Product Name',
//      ),
//      preferences: [
//        PaymentPreference.khalti,
//      ],
//      onSuccess: (su) {
//        const successsnackBar = SnackBar(
//          content: Text('Payment Successful'),
//        );
//        ScaffoldMessenger.of(context)
//            .showSnackBar(successsnackBar);
//      },
//      onFailure: (fa) {
//        const failedsnackBar = SnackBar(
//          content: Text('Payment Failed'),
//        );
//        ScaffoldMessenger.of(context)
//            .showSnackBar(failedsnackBar);
//      },
//      onCancel: () {
//        const cancelsnackBar = SnackBar(
//          content: Text('Payment Cancelled'),
//        );
//        ScaffoldMessenger.of(context)
//            .showSnackBar(cancelsnackBar);
//      },
//    );
    var res = await CallApi().postDataWithoutToken(data, 'appointment/add/');

    var body = json.decode(res.body);
    print(body);
    if (res.statusCode == 200) {

      Navigator.pushReplacementNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment Scheduled Successfully'),
        backgroundColor: Colors.green,
      ));
    } else if (res.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment Already booked'),
        backgroundColor: Colors.redAccent,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment cannot be added'),
        backgroundColor: Colors.redAccent,
      ));
      //   }
      // }
    }
// futureData[i]['date']==date.text && futureData[i]['time']==tame
//
    setState(() {
      _isLoading = false;
    });
  }
}
