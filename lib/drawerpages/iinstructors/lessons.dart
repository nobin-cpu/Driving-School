import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:s/book_a_lesson/choose_instructor.dart';

import 'package:s/login/login.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

class Lessonfromdrawer extends StatefulWidget {
  const Lessonfromdrawer({Key? key}) : super(key: key);

  @override
  State<Lessonfromdrawer> createState() => _LessonfromdrawerState();
}

class _LessonfromdrawerState extends State<Lessonfromdrawer> {
  bool? value1 = false;
  bool? value2 = false;
  bool? manual = false;
  bool? automatic = false;
  bool? standard = false;
  bool? intensive = false;
  bool? block = false;

  final TextEditingController _searchController = TextEditingController();

  void _performSearch() async {
    String searchText = _searchController.text;

    try {
      List<Location> locations = await locationFromAddress(searchText);

      if (locations.isNotEmpty) {
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;

        print('Latitude: $latitude');
        print('Longitude: $longitude');
      } else {
        print('No results found for the given place.');
      }
    } catch (e) {
      print('Error searching for the place: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        toolbarHeight: size.height * .085,
        backgroundColor: Colors.white,
        title: Container(
          height: 100,
          width: 100,
          child: Image.asset(
            "images/logo.png",
            fit: BoxFit.fitWidth,
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Get.to(() => Logins());
                },
                child: CircleAvatar(
                  backgroundColor: Color(0xFF198754),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: size.height * .17,
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * .06),
                        child: Container(
                          height: size.height * .14,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Are You An Exciting Customer!!!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                "Click Below To Login",
                                style: TextStyle(fontSize: 16),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF198754),
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      Get.to(() => Logins());
                                    },
                                    child: Text("Log In")),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                constraints: BoxConstraints(maxHeight: double.infinity),
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width * .06, top: size.height * .02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "The fundamentals",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Just a few questions to determine the type of Lessonfromdrawer or course you would like.",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Do you have a provisional licence? ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    " *",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        value: value1,
                                        activeColor: Colors.blue,
                                        onChanged: (value) {
                                          setState(() {
                                            value1 = value;
                                            value2 = false;
                                          });
                                        },
                                      ),
                                      Text("Yes")
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        value: value2,
                                        activeColor: Colors.blue,
                                        onChanged: (value) {
                                          setState(() {
                                            value1 = false;
                                            value2 = value;
                                          });
                                        },
                                      ),
                                      Text("No")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Car type required ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    " *",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        value: manual,
                                        activeColor: Colors.blue,
                                        onChanged: (value) {
                                          setState(() {
                                            manual = value;
                                            automatic = false;
                                          });
                                        },
                                      ),
                                      Text("Manual")
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        value: automatic,
                                        activeColor: Colors.blue,
                                        onChanged: (value) {
                                          setState(() {
                                            manual = false;
                                            automatic = value;
                                          });
                                        },
                                      ),
                                      Text("Automatic")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Course Type",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    " *",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        value: manual,
                                        activeColor: Colors.blue,
                                        onChanged: (value) {
                                          setState(() {
                                            manual = value;
                                            automatic = false;
                                          });
                                        },
                                      ),
                                      Text("Standard Driving Lessonfromdrawers")
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        value: automatic,
                                        activeColor: Colors.blue,
                                        onChanged: (value) {
                                          setState(() {
                                            manual = false;
                                            automatic = value;
                                          });
                                        },
                                      ),
                                      Text(
                                          "Intensive Driving Lessonfromdrawers")
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        value: automatic,
                                        activeColor: Colors.blue,
                                        onChanged: (value) {
                                          setState(() {
                                            manual = false;
                                            automatic = value;
                                          });
                                        },
                                      ),
                                      Text("Block of 40 Hours ")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Select Location",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    " *",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      labelText: 'Enter A Location',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * .6,
                                        top: 16,
                                        bottom: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _performSearch();
                                        Get.to(() => ChooseInstructor());
                                      },
                                      child: Text('Next'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
