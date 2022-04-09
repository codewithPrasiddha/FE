import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:appointmentapp/constants/Theme.dart';
import 'package:appointmentapp/api/api.dart';
import 'package:appointmentapp/widgets/drawer-tile.dart';
import 'package:appointmentapp/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
//widgets

import 'dart:convert';

Future<String> getGet() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var role = localStorage.getString('r');

  return role;
}

// ignore: must_be_immutable
class NowDrawer extends StatefulWidget {
  String currentPage;

  NowDrawer({this.currentPage});

  @override
  _NowDrawerState createState() => _NowDrawerState();
}

class _NowDrawerState extends State<NowDrawer> {
  final String page;

  _NowDrawerState({this.page});

  Future<String> _role;

  @override
  void initState() {
    super.initState();

    _role = getGet().then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: NowUIColors.primary,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IconButton(
                          icon: Icon(Icons.menu,
                              color: NowUIColors.white.withOpacity(0.82),
                              size: 24.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ],
                ),
              ),
            )),
        FutureBuilder<String>(
          future: _role,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              if (snapshot.data == "1") {
                return Expanded(
                  flex: 2,
                  child: ListView(
                      padding: EdgeInsets.only(top: 36, left: 8, right: 16),
                      children: [
                        DrawerTile(
                            onTap: () {
                              if (page != "3")
                                Navigator.pushReplacementNamed(
                                    context, '/doctor');
                            },
                            iconColor: NowUIColors.info,
                            title: "Doctor",
                            isSelected: page == "Doctor" ? true : false),
                      ]),
                );
              } else if (snapshot.data == "2") {
                return Expanded(
                  flex: 2,
                  child: ListView(
                      padding: EdgeInsets.only(top: 36, left: 8, right: 16),
                      children: [
                        DrawerTile(
                            onTap: () {
                              if (page != "Home")
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                            },
                            iconColor: NowUIColors.info,
                            title: "Home",
                            isSelected: page == "Home" ? true : false),
                        DrawerTile(
                            onTap: () {
                              if (page != "Appointment")
                                Navigator.pushReplacementNamed(
                                    context, '/appointment');
                            },
                            iconColor: NowUIColors.info,
                            title: "Appointment",
                            isSelected: page == "Appointment" ? true : false),
                      ]),
                );
              } else if (snapshot.data == "3") {
                return Expanded(
                  flex: 2,
                  child: ListView(
                      padding: EdgeInsets.only(top: 36, left: 8, right: 16),
                      children: [
                        DrawerTile(
                            onTap: () {
                              if (page != "Appointment")
                                Navigator.pushReplacementNamed(
                                    context, '/appointment');
                            },
                            iconColor: NowUIColors.info,
                            title: "Appointments",
                            isSelected: page == "Appointment" ? true : false),
                      ]),
                );
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default show a loading spinner.
            return Text("");
          },
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.only(left: 8, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                      height: 4,
                      thickness: 0,
                      color: NowUIColors.white.withOpacity(0.8)),
                  DrawerTile(
                      onTap: () async {
                        await CallApi()
                            .postDataWithoutToken({}, 'auth/logout/');

                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        localStorage.remove('token');
                        localStorage.remove('user');
                        localStorage.remove('id');
                        localStorage.remove('r');
                        Navigator.pushNamed(context, '/login');
                      },
                      iconColor: NowUIColors.muted,
                      title: "Logout",
                      isSelected: page == "Getting started" ? true : false),
                ],
              )),
        ),
      ]),
    ));
  }
}
