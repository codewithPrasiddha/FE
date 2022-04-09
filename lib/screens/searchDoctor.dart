import 'package:flutter/material.dart';
import 'package:appointmentapp/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:appointmentapp/constants/Theme.dart';
//import 'package:appointmentapp/screens/med.dart';
import 'package:appointmentapp/screens/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appointmentapp/widgets/input.dart';

//widgets
import 'package:appointmentapp/widgets/drawer.dart';
import 'package:appointmentapp/widgets/navbar.dart';

import 'package:appointmentapp/widgets/card-category.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> articlesCards = {
  "Content": {
    "title": "View Doctors",
    "image":
        "https://images.unsplash.com/photo-1587854692152-cbe660dbde88?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8bWVkaWNpbmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
  }
};
final Map<String, Map<String, String>> homeCards = {
  "Doctors": {
    "title": "Doctors",
    "image":
        "https://images.unsplash.com/photo-1537368910025-700350fe46c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"
  },
  "Appointment": {
    "title": "Appointment",
    "image":
        "https://images.unsplash.com/photo-1624969862293-b749659ccc4e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"
  },
};

class SearchDoctor extends StatefulWidget {
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final String about;
  final String username;

  SearchDoctor(
      {this.id,
      this.first_name,
      this.last_name,
      this.email,
      this.about,
      this.username});

  @override
  _SearchDoctorState createState() => _SearchDoctorState();
}

class _SearchDoctorState extends State<SearchDoctor> {
  String id;

  String first_name;
  String last_name;
  String username;
  String about;
  String email;
  @override
  void initState() {
    super.initState();
//    print(widget.list[0]);
    id = widget.id;
    first_name = widget.first_name;
    last_name = widget.last_name;
    about = widget.about;
    email = widget.email;
    username = widget.username;
//    brand_name=new TextEditingController(text:widget.list[0].brand_name);
//    dosage_form=new TextEditingController(text:widget.list[0].dosage_form);
//    labeler_name=new TextEditingController(text:widget.list[0].labeler_name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Navbar(
          title: "Search Result",
          rightOptions: false,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Doctor"),
        body: Container(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                          child: InkWell(
                            child: Text("<-Back"),
                            onTap: () {
                              Navigator.pushNamed(context, '/home');
                            },
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 32),
                  ),
//                  Center(
//                    child: Container(
//                      child: Card(
//                        child: ListTile(
//                          leading: const Icon(Icons.bloodtype),
//                          title: Text(generic_name),
//                          subtitle: Text('Brand Name: ' +
//                              brand_name +
//                              '\n' +
//                              'Dosage Form ' +
//                              dosage_form +
//                              '\n' +
//                              'Label Company: ' +
//                              labeler_name +
//                              '\n'),
//                          isThreeLine: true,
//                        ),
//                      ),
//                    ),
//                  ),
                  Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      color: Color(0xFFFFFFFF),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CardCategory(
                                          title: "Dr. " +
                                              first_name +
                                              " " +
                                              last_name +
                                              "\n" +
                                              "username: " +
                                              username,
                                          img: homeCards["Doctors"]["image"]),
                                      Row(
                                        children: [
                                          Icon(Icons.star),
                                          Icon(Icons.star),
                                          Icon(Icons.star),
                                          Icon(Icons.star),
                                          Icon(Icons.star),
                                        ],
                                      ),
                                      Text('About')
                                    ],
                                  ),
                                  Row(children: [
                                    Center(
                                      child: RaisedButton(
                                        textColor: NowUIColors.white,
                                        color: NowUIColors.primary,
                                        onPressed: () {},
                                        shape: RoundedRectangleBorder(),
                                        child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text("Consult Online",
                                                style:
                                                    TextStyle(fontSize: 14.0))),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 8.0)),
                                    Center(
                                      child: RaisedButton(
                                        textColor: NowUIColors.white,
                                        color: NowUIColors.primary,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Payment(
                                                        id: widget.id,
                                                        fullName: widget
                                                                .first_name +
                                                            " " +
                                                            widget.last_name,
                                                        email: widget.email,
                                                        about: widget.about,
                                                      )));
                                        },
                                        shape: RoundedRectangleBorder(),
                                        child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text("Book Appointment",
                                                style:
                                                    TextStyle(fontSize: 14.0))),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ))),
                  SizedBox(height: 8.0),
                ],
              ),
            )));
  }
}
