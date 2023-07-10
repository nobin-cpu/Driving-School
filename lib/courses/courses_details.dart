import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:s/courses/coursedetails.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContforCourses extends StatefulWidget {
  const ContforCourses({Key? key}) : super(key: key);

  @override
  State<ContforCourses> createState() => _ContforCoursesState();
}

class _ContforCoursesState extends State<ContforCourses> {
  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.courses), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  Future? home1;
  @override
  void initState() {
    home1 = homes();
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: ScrollPhysics(),
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
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data["courses"].length,
                    itemBuilder: (context, index) {
                      return ShowUpAnimation(
                          delayStart: Duration(milliseconds: 400),
                          animationDuration: Duration(milliseconds: 400),
                          offset: 0.9,
                          curve: Curves.linear,
                          direction: Direction.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Stack(children: [
                                      Container(
                                        height: size.height * .26,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  snapshot.data["courses"]
                                                      [index]["image"],
                                                )),
                                            color: Colors.black,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * .17,
                                            left: size.width * .05),
                                        child: Container(
                                          height: size.height * .07,
                                          width: size.width * .3,
                                          decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Center(
                                                child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snapshot.data["courses"]
                                                                    [index]
                                                                    ["price"]
                                                                .toString() !=
                                                            null
                                                        ? snapshot
                                                            .data["courses"]
                                                                [index]["price"]
                                                            .toString()
                                                        : "N/A" + "\$",
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * .03,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Text(
                                                      "/person",
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * .027,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                          ),
                                        ),
                                      )
                                    ]),
                                    Container(
                                      height: size.height * .3,
                                      width: double.infinity,
                                      color: Color.fromARGB(18, 76, 175, 79),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: Text(
                                              "Block of " +
                                                          snapshot.data[
                                                                      "courses"]
                                                                  [index][
                                                              "course_hours"] !=
                                                      null
                                                  ? snapshot.data["courses"]
                                                      [index]["course_hours"]
                                                  : "N/A",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: Text(
                                              snapshot.data["courses"][index][
                                                          "long_description"] !=
                                                      null
                                                  ? snapshot.data["courses"]
                                                          [index]
                                                      ["long_description"]
                                                  : "N/A",
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: Color.fromARGB(90, 0, 0, 0),
                                          ),
                                          Container(
                                            height: 70,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: size.height *
                                                              .03),
                                                      child: Text(
                                                        "THEORY SESSION",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data["courses"]
                                                                      [index][
                                                                  "theory_session"] !=
                                                              null
                                                          ? snapshot.data[
                                                                      "courses"]
                                                                  [index]
                                                              ["theory_session"]
                                                          : "N/A",
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  height: 49,
                                                  width: 1,
                                                  color: Color.fromARGB(
                                                      90, 0, 0, 0),
                                                ),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: size.height *
                                                              .03),
                                                      child: Text(
                                                        "PRACTICAL SESSION",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data["courses"]
                                                                      [index][
                                                                  "practical_session"] !=
                                                              null
                                                          ? snapshot.data[
                                                                      "courses"]
                                                                  [index][
                                                              "practical_session"]
                                                          : "N/A",
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: size.width * .29),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFF198754),
                                                ),
                                                onPressed: () {
                                                  Get.to(() => CourseDetails(
                                                        desc: snapshot.data["courses"]
                                                                        [index][
                                                                    "long_description"] !=
                                                                null
                                                            ? snapshot.data[
                                                                        "courses"]
                                                                    [index][
                                                                "long_description"]
                                                            : "N/A",
                                                        heading: snapshot.data[
                                                                            "courses"]
                                                                        [index][
                                                                    "short_description"] !=
                                                                null
                                                            ? snapshot.data[
                                                                        "courses"]
                                                                    [index][
                                                                "short_description"]
                                                            : "N/A",
                                                        image: snapshot.data[
                                                                            "courses"]
                                                                        [index]
                                                                    ["image"] !=
                                                                null
                                                            ? snapshot.data[
                                                                    "courses"]
                                                                [index]["image"]
                                                            : "N/A",
                                                      ));
                                                },
                                                child: Text("Course Details")),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                  );
                } else {
                  return Text("No productt found");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
