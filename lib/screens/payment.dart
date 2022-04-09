import 'package:appointmentapp/screens/addAppointment.dart';
import 'package:flutter/material.dart';

import 'package:appointmentapp/constants/Theme.dart';

//widgets
import 'package:appointmentapp/widgets/navbar.dart';
import 'package:appointmentapp/screens/home.dart';
import 'package:appointmentapp/screens/addAppointment.dart';
import 'package:appointmentapp/widgets/card-category.dart';

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
Future<String> getAverageDoctorRating(String id) async {
  final response = await CallApi().getDataWithoutToken('appointment/ratings');
  var body = json.decode(response.body);

  if (response.statusCode == 200) {
    List jsonResponse = body;
    print(jsonResponse.length);
    double averageRating = 0;
    double counter = 0;

    for (var i = 0; i < jsonResponse.length; i++) {
      if (jsonResponse[i]['doctor'].toString() == id.toString()) {
        averageRating += jsonResponse[i]['rating'].toDouble();
        counter++;
      }
    }
    averageRating = averageRating / counter;
    print('Rting is $averageRating');
    return averageRating.toString();
  }
}

class Payment extends StatefulWidget {
  String id;
  String fullName;
  String email;
  String about;

  Payment({this.id, this.fullName, this.email, this.about});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Future<String> userType;
  String doctor_id;
  Future<String> rating;
  @override
  void initState() {
    super.initState();
    doctor_id = widget.id;
    print('doctor id is $doctor_id');
    rating = getAverageDoctorRating(doctor_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          title: "Payment",
        ),
        backgroundColor: Color(0xFFFFFFFF),
        // key: _scaffoldKey,

        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
          ),
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 8.0),
                Center(
                  child: Card(
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
                                          title: widget.fullName,
                                          img:
                                              "https://images.unsplash.com/photo-1537368910025-700350fe46c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
                                      //Rating
                                      FutureBuilder(
                                        future: rating,
                                        builder: (context, snapshot) {
                                          print('data is ${snapshot.data}');
                                          if (snapshot.hasData) {
                                            return Text('Rating: ' +
                                                snapshot.data.toString());
                                          } else {
                                            return Text('Rating: 0');
                                          }
                                        },
                                      ),

                                      Text('Email: ' + widget.email),
                                      Text('About: ' + widget.about),
                                    ],
                                  ),
                                  Text('Charge: Rs. 200' +
                                      '\n' +
                                      'Pay Through Khalti:'),
                                  Center(
                                    child: RaisedButton(
                                      textColor: NowUIColors.white,
                                      color: NowUIColors.primary,
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new AddAppointment(
                                                  index: doctor_id),
                                        ));
                                      },
                                      shape: RoundedRectangleBorder(),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Book Appointment",
                                              style:
                                                  TextStyle(fontSize: 14.0))),
                                    ),
                                  ),
                                  Center(
                                    child: InkWell(
                                      child: Text(
                                        'Back',
                                      ),
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) => Home())),
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))),
                ),
              ],
            ),
          ),
        ));
  }
}
