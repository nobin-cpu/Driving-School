import 'dart:convert';
import 'package:s/profile.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/book_a_lesson/booktime.dart';
import 'package:s/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../App/appurls.dart';

class ChooseInstructor extends StatefulWidget {
  String lat, long, courseId, instructorId, token, price;
  final double timeLimit;
  ChooseInstructor(
      {Key? key,
      required this.lat,
      required this.long,
      required this.courseId,
      required this.instructorId,
      required this.token,
      required this.timeLimit,
      required this.price})
      : super(key: key);

  @override
  State<ChooseInstructor> createState() => _ChooseInstructorState();
}

class _ChooseInstructorState extends State<ChooseInstructor> {
  bool? value1 = false;
  var isSelected = false;
  List<String> name = ["Richard Osei Williams", "Chris Hemsworth", "Jhony Dep"];
  List<String> address = ["15 Lords Avenue", "Dhaka", "California"];
  List<String> temparray = [];
  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(
            "https://precisiondriving.uk/api/intructor-list?latitude=${widget.lat.toString()}&longitude=${widget.long.toString()}"),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print("===========responding");
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    } 
     if (response.statusCode == 401) {
      print("nobin");
      _showPopUp();
    }
    else {
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


  Future? home1;
  @override
  void initState() {
    home1 = homes();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 222, 222, 222),
      appBar: AppBar(
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
          // IconButton(
          //     onPressed: () {
          //       print(widget.lat.toString());
          //     },
          //     icon: Icon(Icons.abc)),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  widget.token != null
                      ? Get.to(() => Profile(
                            token: widget.token,
                          ))
                      : Get.to(() => Logins());
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
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Choose Instructor",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: size.height * .03),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.only(top: 8, left: 10, right: 5),
                  child: Text(
                    "Just a few questions to determine the type of lesson or course you would like.",
                    style: TextStyle(fontSize: size.height * .025),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, left: 10, right: 5),
                child: Row(
                  children: [
                    Text(
                      "Instructor",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * .025),
                    ),
                    Text(
                      "  *",
                      style: TextStyle(
                          fontSize: size.height * .025,
                          color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FutureBuilder(
                  future: home1,
                  builder: (_, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: buildShimmerEffect(),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => TimeandDate(
                                        price: widget.price,
                                        token: widget.token,
                                        timeLimit: widget.timeLimit,
                                        instructorId: snapshot.data[index]
                                                ["instructor_id"]
                                            .toString(),
                                        courseId: widget.courseId,
                                      ));
                                },
                                child: Container(
                                  height: size.height * .16,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .025,
                                                left: size.width * .02),
                                            child: Container(
                                              height: size.height * .12,
                                              width: size.width * .22,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(snapshot
                                                    .data[index]["avatar"]
                                                    .toString()),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .025),
                                            child: Container(
                                              height: size.height * .12,
                                              width: size.width * .55,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    child: Text(
                                                      snapshot.data[index]
                                                              ["name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: temparray
                                                                  .contains(name[
                                                                          index]
                                                                      .toString())
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    child: Text(
                                                      snapshot.data[index]
                                                              ["location"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: temparray
                                                                  .contains(name[
                                                                          index]
                                                                      .toString())
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }));
                    } else {
                      return Image.asset(
                        "images/no-data.gif",
                      );
                    }
                  },
                ),
              )
            ],
          )),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xFF198754),
      //   onPressed: () {
      //     print("thhh" + temparray.toString());
      //     Get.to(() => TimeandDate(
      //           token: widget.token,
      //           timeLimit: 0,
      //           courseId: widget.courseId,
      //           instructorId: widget.instructorId,
      //         ));
      //   },
      //   child: Icon(Icons.arrow_forward),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
