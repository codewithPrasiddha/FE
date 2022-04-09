import 'package:appointmentapp/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appointmentapp/constants/Theme.dart';
import 'package:appointmentapp/screens/searchDoctor.dart';
//widgets
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appointmentapp/widgets/navbar.dart';
import 'package:appointmentapp/widgets/card-horizontal.dart';
import 'package:appointmentapp/widgets/card-small.dart';
import 'package:appointmentapp/widgets/card-category.dart';
import 'package:appointmentapp/widgets/drawer.dart';
import 'package:appointmentapp/screens/payment.dart';
import 'package:appointmentapp/api/api.dart';
import 'dart:convert';

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
Future<List<Data>> fetchData() async {
  final response = await CallApi().getDataWithoutToken('users/');
  var body = json.decode(response.body);

  if (response.statusCode == 200) {
    List doctors = [];
    List jsonResponse = body;

    for (var i = 0; i < jsonResponse.length; i++) {
      if (body[i]['doctor_status']) {
        doctors.add(body[i]);
      }
    }

    return doctors.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String pk;

  final String first_name;
  final String last_name;

  final String email;
  final String username;
  final String about;

//  final String rating;
//  final String about;
//  final String address;

  Data(
      {this.pk,
      this.email,
      this.first_name,
      this.last_name,
      this.username,
      this.about});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        pk: json['id'].toString(),
        email: json['email'],
//        rating: json['profile']['rating'],
//        about:json['profile']['about'],
//        address:json['profile']['address'],

        first_name: json['first_name'],
        last_name: json['last_name'],
        username: json['username'],
        about: json['profile']['about']);
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Data>> futureData;
  Future<String> userType;
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          title: "Home",
        ),
        backgroundColor: Color(0xFFFFFFFF),
        // key: _scaffoldKey,
        drawer: NowDrawer(currentPage: "Home"),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                      child: Input(
                        placeholder: "Search",
                        onChanged: (value) {},
                        controller: search,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                        child: InkWell(
                          child: Text("Search"),
                          onTap: () async {
                            final response = await http.get(Uri.parse(
                                'http://127.0.0.1:8000/api/v1/users/'));
                            var body = json.decode(response.body);
                            String a = '';
                            String b = '';
                            String c = '';
                            String d = '';
                            String e = '';
                            String f = '';
                            if (response.statusCode == 200) {
                              List jsonResponse = body;
                              bool userFound = false;
                              for (var i = 0; i < jsonResponse.length; i++) {
                                print(
                                    '-----------------------------------------');

                                print(body[i]['username']);
                                print(
                                    '------------------dasdad-----------------------');
                                print(search.text);
                                if (body[i]['username'] == search.text) {
                                  userFound = true;
                                  a = body[i]['id'].toString();
                                  b = body[i]['first_name'];
                                  c = body[i]['last_name'];
                                  d = body[i]['username'];
                                  e = body[i]['email'];
                                  f = body[i]['profile']['about'];

                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => SearchDoctor(
                                              id: a,
                                              first_name: b,
                                              last_name: c,
                                              username: d,
                                              email: e,
                                              about: f)));

                                  break;
                                } else {}
                              }
                              if (!userFound) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Doctor not found'),
                                  backgroundColor: Colors.redAccent,
                                ));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Doctor not found'),
                                backgroundColor: Colors.redAccent,
                              ));
                            }
                          },
                        )),
                  ],
                ),
                SizedBox(height: 8.0),
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
                                itemBuilder: (BuildContext context, int index) {
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
                                          color:
                                          Color(0xFFFFFFFF),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                          title: "Dr. " +
                                                              data[index]
                                                                  .first_name +
                                                              " " +
                                                              data[index]
                                                                  .last_name +
                                                              "\n" +
                                                              "Email: " +
                                                              data[index]
                                                                  .email +
                                                              '\n' +
                                                              "Username: " +
                                                              data[index]
                                                                  .username,
                                                          img: homeCards[
                                                                  "Doctors"]
                                                              ["image"]),
                                                      Text(data[index].about)
                                                    ],
                                                  ),
                                                  Row(children: [
                                                    // Center(
                                                    //   child: RaisedButton(
                                                    //     textColor:
                                                    //         NowUIColors.white,
                                                    //     color:
                                                    //         NowUIColors.primary,
                                                    //     onPressed: () {},
                                                    //     shape:
                                                    //         RoundedRectangleBorder(),
                                                    //     child: Padding(
                                                    //         padding:
                                                    //             EdgeInsets.all(
                                                    //                 16.0),
                                                    //         child: Text(
                                                    //             "Consult Online",
                                                    //             style: TextStyle(
                                                    //                 fontSize:
                                                    //                     14.0))),
                                                    //   ),
                                                    // ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0)),
                                                    Center(
                                                      child: RaisedButton(
                                                        textColor:
                                                            NowUIColors.white,
                                                        color:
                                                            NowUIColors.primary,
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Payment(
                                                                            id: data[index].pk,
                                                                            fullName: data[index].first_name +
                                                                                " " +
                                                                                data[index].last_name,
                                                                            email:
                                                                                data[index].email,
                                                                            about:
                                                                                data[index].about,
                                                                          )));
                                                        },
                                                        shape:
                                                            RoundedRectangleBorder(),
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            child: Text(
                                                                "Book Appointment",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.0))),
                                                      ),
                                                    ),
                                                  ]),
                                                ],
                                              ),
                                            ),
                                          )));
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
          ),
        ));
  }
}
