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
import 'booking_details.dart';

class Bookingsdetails extends StatefulWidget {
  final double timeLimit;
  const Bookingsdetails({Key? key, this.timeLimit = 0.0}) : super(key: key);

  @override
  State<Bookingsdetails> createState() => _BookingsdetailsState();
}

class _BookingsdetailsState extends State<Bookingsdetails> {
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
        await http.get(Uri.parse(Appurl.ongoing), headers: requestHeaders);
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

  var data = "";
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
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data["bookings"].length == 0
                            ? 1
                            : snapshot.data["bookings"].length,
                        itemBuilder: ((context, index) {
                          if (snapshot.data["bookings"].length == 0) {
                            return Center(
                              child: Image.asset(
                                "images/no-data.gif",
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height * .33,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .03,
                                            left: size.width * .07),
                                        child: Text(
                                          snapshot.data["bookings"][index]
                                                  ["course"]["title"]
                                              .toString(),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .02,
                                            left: size.width * .07),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Instructor :",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data["bookings"][index]
                                                      ["instructor"]["name"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .003,
                                            left: size.width * .07),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Email :",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data["bookings"][index]
                                                      ["instructor"]["email"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .012,
                                            left: size.width * .07),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Learner :",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data["bookings"][index]
                                                      ["learner"]["name"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .003,
                                            left: size.width * .07),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Email :",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data["bookings"][index]
                                                      ["learner"]["email"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: size.height * .008,
                                            left: size.width * .07),
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: snapshot.data["bookings"]
                                                              [index]
                                                              ["payment_status"]
                                                          .toString() ==
                                                      "Paid"
                                                  ? Colors.green
                                                  : Colors.red),
                                          child: Text(
                                            snapshot.data["bookings"][index]
                                                    ["payment_status"]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * .7, top: 10),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Color(0xFF198754),
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onPressed: () {
                                              Get.to(() =>
                                                  OngoingBookingDetails(
                                                    timeLimit: snapshot.data[
                                                                "bookings"]
                                                            [index]["course"]
                                                        ["course_hours"],
                                                    instructorId: snapshot
                                                        .data["bookings"][index]
                                                            ["instructor"]
                                                            ["instructor_id"]
                                                        .toString(),
                                                    courseHour: snapshot.data[
                                                                "bookings"]
                                                            [index]["course"]
                                                        ["course_hours"],
                                                    carType: snapshot
                                                        .data["bookings"][index]
                                                            ["car_type"]
                                                        .toString(),
                                                    haslicence: snapshot
                                                        .data["bookings"][index]
                                                            [
                                                            "has_provisional_licence"]
                                                        .toString(),
                                                    title: snapshot
                                                        .data["bookings"][index]
                                                            ["course"]["title"]
                                                        .toString(),
                                                    price: snapshot.data[
                                                            "bookings"][index]
                                                        ["course"]["price"],
                                                    bokingId: snapshot
                                                        .data["bookings"][index]
                                                            ["booking_id"]
                                                        .toString(),
                                                  ));
                                            },
                                            child: Text("Details")),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }))
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
