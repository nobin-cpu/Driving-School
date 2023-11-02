import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:s/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:show_up_animation/show_up_animation.dart';

import 'package:http/http.dart' as http;

class RapidSupport extends StatefulWidget {
  final String id, userId;
  const RapidSupport({Key? key, required this.id, required this.userId})
      : super(key: key);

  @override
  State<RapidSupport> createState() => _RapidSupportState();
}

class _RapidSupportState extends State<RapidSupport> {
  Future getSingleTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? usertype = prefs.getString('type');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(
            "https://precisiondriving.uk/api/support/ticket/${widget.id}/show"),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    }
    if (response.statusCode == 401) {
      // _showPopUp();
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
    home1 = getSingleTicket();
    print("object");
    super.initState();
  }

  TextEditingController comment = TextEditingController();

  Future create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? instIDS = prefs.getString("Instid");

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(
          "https://precisiondriving.uk/api/support/ticket/${widget.id}/reply"),
    );
    request.fields.addAll({
      'description': comment.text,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("massge sent");
          var data = jsonDecode(response.body);
          // saveprefs(data['data']["user_data"]["type"]);
          print("_______________++++++++++_______success");
          setState(() {
            Get.offAll(RapidSupport(
              id: widget.id.toString(),
              userId: widget.userId.toString(),
            ));
            comment.clear();
          });
        } else {
          print("Fail! ");
          print(response.body.toString());
          Fluttertoast.showToast(
              msg: "Error Occured",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return response.body;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data["tickets"]["subject"]
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
                                        "Ticket code :",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data["tickets"]["ticket_code"]
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
                                        "Status :",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data["tickets"]["status"]
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
                                        "Priority :",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data["tickets"]["priority"]
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
                                        "Description: ",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data["tickets"]["description"]
                                            .toString(),
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, bottom: 8, left: 10),
                          child: Text(
                            "Comment",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: 4,
                            controller: comment,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3,
                                    color: Color(0xFF198754),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF198754),
                                  ),
                                ),
                                hintText: 'Description'),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 7),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF198754),
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  create();
                                },
                                child: Text("Send")),
                          ),
                        ),
                        ShowUpAnimation(
                          delayStart: Duration(milliseconds: 400),
                          animationDuration: Duration(milliseconds: 400),
                          offset: -0.9,
                          curve: Curves.linear,
                          direction: Direction.horizontal,
                          child: FutureBuilder(
                            future: home1,
                            builder: (_, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: buildShimmerEffect(),
                                );
                              } else if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot
                                                    .data["tickets"]["replies"]
                                                    .length ==
                                                0
                                            ? 1
                                            : snapshot
                                                .data["tickets"]["replies"]
                                                .length,
                                        itemBuilder: ((context, index) {
                                          if (snapshot
                                                  .data["tickets"]["replies"]
                                                  .length ==
                                              0) {
                                            return Center(
                                              child: Image.asset(
                                                "images/giphy.gif",
                                              ),
                                            );
                                          } else {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                  crossAxisAlignment: snapshot
                                                              .data["tickets"]
                                                                  ["replies"]
                                                                  [index]
                                                                  ["user"]
                                                              .toString() ==
                                                          widget.userId
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top:
                                                              size.height * .02,
                                                          left: size.width *
                                                              .015),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center, // Align children to the end (last item)
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Card(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment: snapshot
                                                                            .data["tickets"]["replies"][index][
                                                                                "user"]
                                                                            .toString() ==
                                                                        widget
                                                                            .userId
                                                                    ? CrossAxisAlignment
                                                                        .end
                                                                    : CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    snapshot
                                                                        .data[
                                                                            "tickets"]
                                                                            [
                                                                            "replies"]
                                                                            [
                                                                            index]
                                                                            [
                                                                            "description"]
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    snapshot
                                                                        .data[
                                                                            "tickets"]
                                                                            [
                                                                            "replies"]
                                                                            [
                                                                            index]
                                                                            [
                                                                            "created_at"]
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        }))
                                  ],
                                );
                              } else {
                                return Image.asset(
                                  "images/giphy.gif",
                                );
                              }
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return Image.asset(
                      "images/giphy.gif",
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
