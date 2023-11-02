import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
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
import 'package:shimmer/shimmer.dart';

class ContforCourses extends StatefulWidget {
  final String token;
  const ContforCourses({Key? key, required this.token}) : super(key: key);

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
      print("get it==============");
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
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
                    child: buildShimmerEffect(),
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
                                                          snapshot
                                                              .data["courses"]
                                                                  [index]
                                                                  ["headline"]
                                                              .toString() !=
                                                      null
                                                  ? snapshot.data["courses"]
                                                          [index]["headline"]
                                                      .toString()
                                                  : "N/A",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: Row(
                                              children: [
                                                Text("Total : ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  "${snapshot.data["courses"][index]["course_hours"]}" !=
                                                          null
                                                      ? "${snapshot.data["courses"][index]["course_hours"]}  Hours"
                                                      : "N/A",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: SingleChildScrollView(
                                              child: Html(
                                                shrinkWrap: true,
                                                data: snapshot.data["courses"]
                                                                [index][
                                                            "long_description"] !=
                                                        null
                                                    ? snapshot.data["courses"]
                                                            [index]
                                                        ["long_description"]
                                                    : "N/A",
                                                // maxLines: 3,
                                                // overflow: TextOverflow.ellipsis,
                                                // style: TextStyle(fontSize: 16),
                                              ),
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
                                                        price: snapshot
                                                                .data["courses"]
                                                                    [index]
                                                                    ["price"]
                                                                .toString() ??
                                                            "",
                                                        totaltime: snapshot
                                                                .data["courses"]
                                                                    [index][
                                                                    "course_hours"]
                                                                .toString() ??
                                                            "",
                                                        timelimit: double.parse(snapshot
                                                                    .data[
                                                                        "courses"]
                                                                        [index][
                                                                        "course_hours"]
                                                                    .toString()) !=
                                                                null
                                                            ? double.parse(snapshot
                                                                .data["courses"]
                                                                    [index][
                                                                    "course_hours"]
                                                                .toString())
                                                            : 0.0,
                                                        token: widget.token,
                                                        id: snapshot.data[
                                                                        "courses"]
                                                                        [index][
                                                                        "course_id"]
                                                                    .toString() !=
                                                                null
                                                            ? snapshot
                                                                .data["courses"]
                                                                    [index][
                                                                    "course_id"]
                                                                .toString()
                                                            : "N/A",
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
                  return Image.asset(
                    "images/no-data.gif",
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
