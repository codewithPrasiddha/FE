import 'package:flutter/material.dart';
import 'package:appointmentapp/api/api.dart';

import 'package:appointmentapp/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:appointmentapp/screens/chat.dart';
//widgets
import 'package:appointmentapp/widgets/drawer.dart';
import 'package:appointmentapp/widgets/navbar.dart';

import 'package:appointmentapp/widgets/card-category.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:appointmentapp/screens/rate.dart';

final Map<String, Map<String, String>> homeCards = {
  "Patients": {
    "title": "Doctors",
    "image":
        "https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHBhdGllbnR8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"
  },
  "Appointment": {
    "title": "Appointment",
    "image":
        "https://images.unsplash.com/photo-1624969862293-b749659ccc4e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"
  },
};
Future<String> getGetData() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var role = localStorage.getString('r');

  return role;
}

Future<List<Data>> fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response =
      await CallApi().getGet('appointment/', prefs.getString('token'));

  var id = prefs.getString('id');
  var r = prefs.getString('r');
  print(id);
  print("----------");
  print(r);
  var body = json.decode(response.body);
  print("<<<<<<BODYYYYY>>>>>>>>>");
  print(body);

  List doc = [];
  if (response.statusCode == 200) {
    List jsonResponse = body;
    if (r == "3") {
      print("here1111");
      for (int i = 0; i < jsonResponse.length; i++) {
        if (jsonResponse[i]['doctor_id']['id'].toString() == id) {
          doc.add(jsonResponse[i]);
        }
      }
    }
    if (r == "2") {
      print("hereree222222");
      for (int i = 0; i < jsonResponse.length; i++) {
        if (jsonResponse[i]['client_id']['id'].toString() == id) {
          doc.add(jsonResponse[i]);
        }
      }
    }
    return doc.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final int id;
  final bool status;
  final int client_id;
  final int doctor_id;
  final String time;
  final String date;
  final String client;
  final String doctor;

  Data(
      {this.id,
      this.client_id,
      this.doctor_id,
      this.client,
      this.doctor,
      this.date,
      this.status,
      this.time});

  factory Data.fromJson(Map<String, dynamic> json) {
    print(json['doctor_id']['id']);
    return Data(
      id: json['id'],
      client_id: json['client_id']['id'],
      doctor_id: json['doctor_id']['id'],
      client: json['client_id']['first_name'] +
          ' ' +
          json['client_id']['last_name'],
      doctor: json['doctor_id']['first_name'] +
          ' ' +
          json['doctor_id']['last_name'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }
}

class Appointment extends StatefulWidget {
  Appointment({Key key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  Future<List<Data>> futureData;
  Future<String> userType;
  String _role;
  @override
  void initState() {
    super.initState();
    getGetData().then((value) => _role = value);
    futureData = fetchData();
    print("<<<<<<ROLE>>>>>>>>>");
    print(_role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Appointments",
          rightOptions: false,
        ),
        drawer: NowDrawer(currentPage: "Appointments"),
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                  ),
                  Text('Upcoming Appointments',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                  ),
                  Center(
                    child: FutureBuilder<List<Data>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data> data = snapshot.data;
                          return Container(
                              color: Color(0xFFFFFFFF),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                        elevation: 5,
                                        clipBehavior: Clip.antiAlias,
                                        color: Color(0xFFFFFFFF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.78,
                                            color: Color(0xFFFFFFFF),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CardCategory(
                                                            title: data[index]
                                                                .client,
                                                            img: homeCards[
                                                                    "Patients"]
                                                                ["image"]),
                                                        Text(
                                                          'Doctor: ' +
                                                              data[index]
                                                                  .doctor +
                                                              '\n' +
                                                              "Date: " +
                                                              data[index].date,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Text(
                                                          "Time: " +
                                                              data[index].time,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Text(
                                                          data[index].status
                                                              ? "Status: Physical"
                                                              : "Status: Online",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Center(
                                                              child:
                                                                  RaisedButton(
                                                                textColor:
                                                                    NowUIColors
                                                                        .white,
                                                                color:
                                                                    NowUIColors
                                                                        .primary,
                                                                onPressed: () {
                                                                  // Respond to button press
                                                                  Navigator.push(
                                                                      context,
                                                                      new MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Rate(doctor: data[index].doctor_id.toString())));
                                                                },
                                                                shape:
                                                                    RoundedRectangleBorder(),
                                                                child: Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            16.0),
                                                                    child: Text(
                                                                        "Rate",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14.0))),
                                                              ),
                                                            ),
                                                            !data[index].status
                                                                ? Center(
                                                                    child:
                                                                        RaisedButton(
                                                                      textColor:
                                                                          NowUIColors
                                                                              .white,
                                                                      color: NowUIColors
                                                                          .primary,
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            "----------------------------------ROLE-------------------");
                                                                        print(
                                                                            _role);
                                                                        print(
                                                                            "appointment.dart");
                                                                        print(
                                                                            "patient");
                                                                        print(data[index]
                                                                            .client_id);
                                                                        print(
                                                                            "doctor");
                                                                        print(data[index]
                                                                            .doctor_id);
                                                                        if (_role ==
                                                                            '2') {
                                                                          Navigator.of(context)
                                                                              .push(new MaterialPageRoute(
                                                                            builder: (BuildContext context) =>
                                                                                new ChatPage(username: (data[index].client_id).toString(), receiver: (data[index].doctor_id).toString()),
                                                                          ));
                                                                        } else if (_role ==
                                                                            '3') {
                                                                          Navigator.of(context)
                                                                              .push(new MaterialPageRoute(
                                                                            builder: (BuildContext context) =>
                                                                                new ChatPage(username: (data[index].doctor_id).toString(), receiver: (data[index].client_id).toString()),
                                                                          ));
                                                                        }
                                                                      },
                                                                      shape:
                                                                          RoundedRectangleBorder(),
                                                                      child: Padding(
                                                                          padding: EdgeInsets.all(
                                                                              16.0),
                                                                          child: Text(
                                                                              "Chat",
                                                                              style: TextStyle(fontSize: 14.0))),
                                                                    ),
                                                                  )
                                                                : Text(''),
                                                            Center(
                                                              child:
                                                                  RaisedButton(
                                                                textColor:
                                                                    NowUIColors
                                                                        .white,
                                                                color:
                                                                    NowUIColors
                                                                        .primary,
                                                                onPressed:
                                                                    () async {
                                                                  // Respond to button press
                                                                  try {
                                                                    SharedPreferences
                                                                        localStorage =
                                                                        await SharedPreferences
                                                                            .getInstance();
                                                                    var tokenString =
                                                                        localStorage
                                                                            .getString('token');

                                                                    await CallApi().deleteData(
                                                                        'appointment/remove/' +
                                                                            (data[index].id).toString(),
                                                                        tokenString);
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            SnackBar(
                                                                      content: Text(
                                                                          'Appointment cancelled Successfully'),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                    ));
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        '/appointment');
                                                                  } catch (e) {
                                                                    print(e);
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            SnackBar(
                                                                      content: Text(
                                                                          'Cannot cancel the Appointment'),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .redAccent,
                                                                    ));
                                                                  }
                                                                },
                                                                shape:
                                                                    RoundedRectangleBorder(),
                                                                child: Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            16.0),
                                                                    child: Text(
                                                                        "Cancel",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14.0))),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )));
                                  }));
                        } else if (snapshot.hasError) {
                          print("khai");
                          print(snapshot.data);
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
