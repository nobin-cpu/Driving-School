import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s/login/login.dart';
import 'package:s/support/widgets/rapid_support.dart';
import 'package:s/support/widgets/ticket_creation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:http/http.dart' as http;
import '../../App/appurls.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({Key? key}) : super(key: key);

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? usertype = prefs.getString('type');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(Appurl.getTicketList),
        headers: requestHeaders);
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => TicketCreation());
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Color(0xFF198754),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                "Tap to create a ticket",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
            ),
          ),
          SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () {
                return homes();
              },
              child: ShowUpAnimation(
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
                              itemCount: snapshot.data["tickets"].length == 0
                                  ? 1
                                  : snapshot.data["tickets"].length,
                              itemBuilder: ((context, index) {
                                if (snapshot.data["tickets"].length == 0) {
                                  return Center(
                                    child: Image.asset(
                                      "images/no-data.gif",
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Container(
                                            //   height: size.height * .08,
                                            //   width: double.infinity,
                                            //   child: Center(
                                            //     child: Stack(children: [
                                            //       // CircleAvatar(
                                            //       //   radius: size.height * .07,
                                            //       //   backgroundImage: NetworkImage(
                                            //       //     snapshot.data["tickets"][index]
                                            //       //         ["avatar"],
                                            //       //   ),
                                            //       // ),
                                            //     ]),
                                            //   ),
                                            // ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: size.height * .02,
                                                  left: size.width * .07),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Subject :",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    snapshot.data["tickets"]
                                                            [index]["subject"]
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 17),
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
                                                    "Ticket code :",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    snapshot.data["tickets"]
                                                            [index]
                                                            ["ticket_code"]
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: size.height * .02,
                                                  left: size.width * .07),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "End Date :",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    snapshot.data["tickets"]
                                                            [index]["end_date"]
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: size.height * .02,
                                                  left: size.width * .07),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Description :",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      snapshot.data["tickets"]
                                                              [index]
                                                              ["description"]
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.width * .4,
                                                  top: 10,
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Color(0xFF198754),
                                                          textStyle: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  onPressed: () {
                                                    Get.to(() => RapidSupport(
                                                          id: snapshot
                                                              .data["tickets"]
                                                                  [index]["id"]
                                                              .toString(),
                                                          userId: snapshot
                                                              .data["tickets"]
                                                                  [index]
                                                                  ["user"]
                                                              .toString(),
                                                        ));
                                                  },
                                                  child: Text(
                                                      "Contact Rapid Support")),
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
