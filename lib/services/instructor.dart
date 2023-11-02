import 'dart:convert';
import 'package:s/services/instructor_details.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/book_a_lesson/book_a_lesson.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../App/appurls.dart';

class Instructors extends StatefulWidget {
  final String token;
  const Instructors({Key? key, required this.token}) : super(key: key);

  @override
  State<Instructors> createState() => _InstructorsState();
}

class _InstructorsState extends State<Instructors> {
  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.instructors), headers: requestHeaders);
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

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: 200.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        FutureBuilder(
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
                  itemCount: snapshot.data["instructors"].length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => InstructorDetails(
                              token: widget.token,
                              valfordrawer: "1",
                              lat: snapshot.data["instructors"][index]
                                  ["latitude"],
                              long: snapshot.data["instructors"][index]
                                  ["longitude"],
                              image: snapshot.data["instructors"][index]
                                  ["avatar"],
                              name: snapshot.data["instructors"][index]["name"],
                              address: snapshot.data["instructors"][index]
                                  ["address"],
                              email: snapshot.data["instructors"][index]
                                  ["email"],
                              number: snapshot.data["instructors"][index]
                                  ["phone"],
                              id: snapshot.data["instructors"][index]
                                      ["instructor_id"]
                                  .toString()));
                        },
                        child: Container(
                          height: size.height * .2,
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => InstructorDetails(
                                        token: widget.token,
                                        valfordrawer: "1",
                                        lat: snapshot.data["instructors"][index]
                                            ["latitude"],
                                        long: snapshot.data["instructors"]
                                            [index]["longitude"],
                                        image: snapshot.data["instructors"]
                                            [index]["avatar"],
                                        name: snapshot.data["instructors"]
                                            [index]["name"],
                                        address: snapshot.data["instructors"]
                                            [index]["address"],
                                        email: snapshot.data["instructors"]
                                            [index]["email"],
                                        number: snapshot.data["instructors"]
                                            [index]["phone"],
                                        id: snapshot.data["instructors"][index]["instructor_id"].toString()));
                                  },
                                  child: Container(
                                    height: size.height * .15,
                                    width: size.width * .28,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data["instructors"]
                                                    [index]["avatar"]))),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Spacer(),
                                Container(
                                  height: size.height * .15,
                                  width: size.width * .62,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data["instructors"][index]
                                            ["name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        snapshot.data["instructors"][index]
                                            ["location"],
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          snapshot.data["instructors"][index]
                                              ["phone"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(0xFF198754),
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            Get.to(() => BookALesson(
                                                  price: "",
                                                  timeLimit: 0,
                                                  token: widget.token,
                                                  instructorId: snapshot
                                                      .data["instructors"]
                                                          [index]
                                                          ["instructor_id"]
                                                      .toString(),
                                                  courseId: '0',
                                                  lat: snapshot
                                                          .data["instructors"]
                                                      [index]["latitude"],
                                                  long: snapshot
                                                          .data["instructors"]
                                                      [index]["longitude"],
                                                ));
                                          },
                                          child: Text("Book Now"))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }));
            } else {
              return  Image.asset(
                  "images/no-data.gif",
                );
            }
          },
        ),
      ],
    );
  }
}
