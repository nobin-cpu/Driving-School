import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/login/login.dart';
import 'package:s/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:http/http.dart' as http;
import '../../App/appurls.dart';

class AllLearners extends StatefulWidget {
  final double timeLimit;
  const AllLearners({Key? key, this.timeLimit = 0.0}) : super(key: key);

  @override
  State<AllLearners> createState() => _AllLearnersState();
}

class _AllLearnersState extends State<AllLearners> {
  String user = "";
  String token = "";

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
        await http.get(Uri.parse(Appurl.allLearners), headers: requestHeaders);
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: token == null ? false : true,
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
                  token != null
                      ? Get.to(() => Profile(
                            token: token,
                          ))
                      : Get.to(() => Logins());
                },
                child: const CircleAvatar(
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
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data["learners"].length == 0
                                ? 1
                                : snapshot.data["learners"].length,
                            itemBuilder: ((context, index) {
                              if (snapshot.data["learners"].length == 0) {
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
                                          Container(
                                            height: size.height * .08,
                                            width: double.infinity,
                                            child: Center(
                                              child: Stack(children: [
                                                CircleAvatar(
                                                  radius: size.height * .07,
                                                  backgroundImage: NetworkImage(
                                                    snapshot.data["learners"]
                                                        [index]["avatar"],
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .02,
                                                left: size.width * .07),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Name :",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data["learners"]
                                                          [index]["name"]
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
                                                  "Email :",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data["learners"]
                                                          [index]["email"]
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
                                                  "Phone :",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data["learners"]
                                                          [index]["phone"]
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: size.width * .55,
                                                top: 10,
                                                bottom: 10),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color(0xFF198754),
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                onPressed: () {
                                                  Get.to(() {});
                                                },
                                                child: Text("Remove Learner")),
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
        ),
      ),
    );
  }
}
