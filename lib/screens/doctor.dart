import 'package:flutter/material.dart';
import 'package:appointmentapp/api/api.dart';

import 'package:appointmentapp/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widgets
import 'package:appointmentapp/widgets/drawer.dart';
import 'package:appointmentapp/widgets/navbar.dart';

import 'package:appointmentapp/widgets/card-category.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View trainer",
    "image":
        "https://images.unsplash.com/photo-1576602975754-efdf313b9342?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHBoYXJtYWN5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
  }
};

Future<List<Data>> fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await CallApi().getGet('users/', prefs.getString('token'));
  var body = json.decode(response.body);
  print(body);
  List doc = [];
  if (response.statusCode == 200) {
    List jsonResponse = body;
    for (int i = 0; i < jsonResponse.length; i++) {
      if (body[i]['doctor_status']) {
        doc.add(jsonResponse[i]);
      }
    }
    return doc.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String id;

  final String first_name;
  final String last_name;

  final String email;

  Data({
    this.id,
    this.email,
    this.first_name,
    this.last_name,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
    );
  }
}

class Doctor extends StatefulWidget {
  Doctor({Key key}) : super(key: key);

  @override
  _DoctorState createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  Future<List<Data>> futureData;
  Future<String> userType;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFFFFFFF),
        appBar: Navbar(
          title: "Doctors",
          rightOptions: false,
        ),
        drawer: NowDrawer(currentPage: "Doctors"),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            color: Color(0xFFFFFFFF),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  Center(
                    child: RaisedButton(
                      textColor: NowUIColors.white,
                      color: NowUIColors.primary,
                      onPressed: () {
                        // Respond to button press
                        Navigator.pushReplacementNamed(context, '/addDoctor');
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 32.0, right: 32.0, top: 12, bottom: 12),
                          child: Text("Add Doctor",
                              style: TextStyle(fontSize: 14.0))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  Text('All Doctors',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Center(
                    child: FutureBuilder<List<Data>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data> data = snapshot.data;
                          return Container(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      color: Color(0xFFFFFFFF),
                                      child: ListTile(
                                        leading:
                                            const Icon(Icons.local_hospital),
                                        title: Text(data[index].first_name +
                                            " " +
                                            data[index].last_name),
                                        subtitle: Text('Email: ' +
                                            data[index].email +
                                            '\n'),
                                        trailing: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              OutlinedButton.icon(
                                                onPressed: () async {
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
                                                        'users/' +
                                                            data[index].id,
                                                        tokenString);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Doctor removed'),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                    Navigator.pushNamed(
                                                        context, '/doctor');
                                                  } catch (e) {
                                                    print(e);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Cannot remove the Doctor'),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                    ));
                                                  }
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red),
                                                label: Text(""),
                                              ),
                                            ],
                                          ),
                                        ),
                                        isThreeLine: true,
                                      ),
                                    );
                                  }));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
