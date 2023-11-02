import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:http/http.dart' as http;
import '../../App/appurls.dart';

class Dashcardss extends StatefulWidget {
  const Dashcardss({Key? key}) : super(key: key);

  @override
  State<Dashcardss> createState() => _DashcardssState();
}

class _DashcardssState extends State<Dashcardss> {
  String user = "";

  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? usertype = prefs.getString('type');

    user = usertype.toString();

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.dashoard), headers: requestHeaders);
    if (response.statusCode == 200) {
      print("get it==============");
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    }
    if (response.statusCode == 401) {
      _showPopUp();
    } else {
      print(token);
      print("post have no Data${response.body}");
    }
  }

  void _showPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session Expired'),
          content: Text('To continue go to login page'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
              child: Text('Ok'),
              onPressed: () {
                Get.to(() => Logins());
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: 400.0,
        color: Colors.white,
      ),
    );
  }

  Future? home1;
  @override
  void initState() {
    home1 = homes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        ShowUpAnimation(
          delayStart: Duration(milliseconds: 400),
          animationDuration: Duration(milliseconds: 400),
          offset: -0.9,
          curve: Curves.linear,
          direction: Direction.horizontal,
          child: FutureBuilder(
            future: home1,
            builder: (_, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: buildShimmerEffect(),
                );
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    user != "instructor"
                        ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  print(user);
                                },
                                child: Container(
                                  height: size.height * .3,
                                  width: double.infinity,
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * .03,
                                              left: size.width * .06),
                                          child: CircleAvatar(
                                            maxRadius: size.height * .035,
                                            backgroundColor: Color.fromARGB(
                                                255, 225, 255, 77),
                                            child: Icon(
                                              Icons.task_alt,
                                              color: Colors.white,
                                              size: size.height * .04,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * .02,
                                              left: size.width * .07),
                                          child: Text(
                                            "Total",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * .015,
                                              left: size.width * .07),
                                          child: Text(
                                            "Number Of Courses",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * .028,
                                              left: size.width * .07),
                                          child: Text(
                                            snapshot.data["number_of_courses"]
                                                .toString(),
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * .3,
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .03,
                                            left: size.width * .06),
                                        child: CircleAvatar(
                                          maxRadius: size.height * .035,
                                          backgroundColor: Colors.orange,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: size.height * .04,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .02,
                                            left: size.width * .07),
                                        child: Text(
                                          "Total",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .015,
                                            left: size.width * .07),
                                        child: Text(
                                          "Number Of Connected Instructors",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .028,
                                            left: size.width * .07),
                                        child: Text(
                                          snapshot.data[
                                                  "number_of_connected_instructors"]
                                              .toString(),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * .3,
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .03,
                                            left: size.width * .06),
                                        child: CircleAvatar(
                                          maxRadius: size.height * .035,
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.book_online,
                                            color: Colors.white,
                                            size: size.height * .04,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .02,
                                            left: size.width * .07),
                                        child: Text(
                                          "Total",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .015,
                                            left: size.width * .07),
                                        child: Text(
                                          "Number Of Bookings",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .028,
                                            left: size.width * .07),
                                        child: Text(
                                          snapshot.data["number_of_booking"]
                                              .toString(),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * .3,
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .03,
                                            left: size.width * .06),
                                        child: CircleAvatar(
                                          maxRadius: size.height * .035,
                                          backgroundColor:
                                              Colors.deepPurpleAccent,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: size.height * .04,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .02,
                                            left: size.width * .07),
                                        child: Text(
                                          "Total",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .015,
                                            left: size.width * .07),
                                        child: Text(
                                          "Number Of Instructor",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .028,
                                            left: size.width * .07),
                                        child: Text(
                                          snapshot.data["number_of_instructors"]
                                              .toString(),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  print(user);
                                },
                                child: Container(
                                  height: size.height * .3,
                                  width: double.infinity,
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * .03,
                                              left: size.width * .06),
                                          child: CircleAvatar(
                                            maxRadius: size.height * .035,
                                            backgroundColor:
                                                Colors.deepPurpleAccent,
                                            child: Icon(
                                              Icons.task_alt,
                                              color: Colors.white,
                                              size: size.height * .04,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * .02,
                                              left: size.width * .07),
                                          child: Text(
                                            "Total",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * .015,
                                              left: size.width * .07),
                                          child: Text(
                                            "Number Of Bookings",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * .028,
                                              left: size.width * .07),
                                          child: Text(
                                            snapshot.data["number_of_booking"]
                                                .toString(),
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * .3,
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .03,
                                            left: size.width * .06),
                                        child: CircleAvatar(
                                          maxRadius: size.height * .035,
                                          backgroundColor: Colors.yellow,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: size.height * .04,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .02,
                                            left: size.width * .07),
                                        child: Text(
                                          "Total",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .015,
                                            left: size.width * .07),
                                        child: Text(
                                          "Number Of Connected Learners",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .028,
                                            left: size.width * .07),
                                        child: Text(
                                          snapshot.data[
                                                  "number_of_connected_learners"]
                                              .toString(),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * .3,
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .03,
                                            left: size.width * .06),
                                        child: CircleAvatar(
                                          maxRadius: size.height * .035,
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.book_online,
                                            color: Colors.white,
                                            size: size.height * .04,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .02,
                                            left: size.width * .07),
                                        child: Text(
                                          "Total",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .015,
                                            left: size.width * .07),
                                        child: Text(
                                          "Number Of Courses",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .028,
                                            left: size.width * .07),
                                        child: Text(
                                          snapshot.data["number_of_courses"]
                                              .toString(),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * .3,
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .03,
                                            left: size.width * .06),
                                        child: CircleAvatar(
                                          maxRadius: size.height * .035,
                                          backgroundColor: Colors.blue,
                                          child: Icon(
                                            Icons.money,
                                            color: Colors.white,
                                            size: size.height * .04,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .02,
                                            left: size.width * .07),
                                        child: Text(
                                          "Total",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .015,
                                            left: size.width * .07),
                                        child: Text(
                                          "Total Earnings",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .028,
                                            left: size.width * .07),
                                        child: Text(
                                          snapshot.data["total_earnings"]
                                              .toString(),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                  ],
                );
              } else {
                return Image.asset(
                  "images/no-data.gif",
                );
              }
            },
          ),
        )
      ],
    );
  }
}
