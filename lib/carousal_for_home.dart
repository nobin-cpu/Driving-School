import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:s/book_a_lesson/book_a_lesson.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Carous extends StatefulWidget {
  const Carous({Key? key}) : super(key: key);

  @override
  State<Carous> createState() => _CarousState();
}

class _CarousState extends State<Carous> {
  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.homes), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  Future? home2;
  @override
  void initState() {
    home2 = homes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: FutureBuilder(
        future: home2,
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              
            );
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              reverse: true,
              physics: ScrollPhysics(),
              child: CarouselSlider(
                items: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: double.infinity),
                      decoration: BoxDecoration(
                        color: Color(0xFF198754),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(blurRadius: 5.0, spreadRadius: .4),
                        ],
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 30, top: size.height * .04),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(180, 135, 210, 129),
                                  child: Icon(
                                    Icons.badge_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Driving",
                                  style: TextStyle(
                                      fontSize: size.height * .03,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * .06,
                                right: size.width * .04,
                                top: size.height * .02),
                            child: Text(
                                snapshot.data["contents"]
                                    ["hero_section_driving_license"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 6,
                                style: TextStyle(
                                    fontSize: size.height * .02,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Spacer(),
                          Padding(
                              padding: EdgeInsets.only(
                                left: size.width * .06,
                                right: size.width * .04,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => BookALesson());
                                },
                                child: Text(
                                  "BOOK A LESSON >>",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .02),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF198754),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(blurRadius: 5.0, spreadRadius: .4),
                        ],
                      ),
                      constraints: BoxConstraints(maxHeight: double.infinity),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 30, top: size.height * .04),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(180, 135, 210, 129),
                                  child: Icon(
                                    Icons.badge_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Instructor Training",
                                  style: TextStyle(
                                      fontSize: size.height * .03,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * .06,
                                right: size.width * .04,
                                top: size.height * .02),
                            child: Text(
                                snapshot.data["contents"]
                                    ["hero_section_instructor_training"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 6,
                                style: TextStyle(
                                    fontSize: size.height * .02,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Spacer(),
                          Padding(
                              padding: EdgeInsets.only(
                                left: size.width * .06,
                                right: size.width * .04,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => BookALesson());
                                },
                                child: Text(
                                  "GET STARTED  >>",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .02),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF198754),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(blurRadius: 5.0, spreadRadius: .4),
                        ],
                      ),
                      constraints: BoxConstraints(maxHeight: double.infinity),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 30, top: size.height * .04),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(180, 135, 210, 129),
                                  child: Icon(
                                    Icons.badge_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    "Traffic Guidelines",
                                    style: TextStyle(
                                        fontSize: size.height * .03,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * .06,
                                right: size.width * .04,
                                top: size.height * .02),
                            child: Text(
                                snapshot.data["contents"]
                                    ["hero_section_traffic_guidline"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 6,
                                style: TextStyle(
                                    fontSize: size.height * .02,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Spacer(),
                          Padding(
                              padding: EdgeInsets.only(
                                left: size.width * .06,
                                right: size.width * .04,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => BookALesson());
                                },
                                child: Text(
                                  "FIND OUT MORE >>",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .02),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF198754),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(blurRadius: 5.0, spreadRadius: .4),
                        ],
                      ),
                      constraints: BoxConstraints(maxHeight: double.infinity),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 30, top: size.height * .04),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(180, 135, 210, 129),
                                  child: Icon(
                                    Icons.badge_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Vesicle Insurance",
                                  style: TextStyle(
                                      fontSize: size.height * .03,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * .06,
                                right: size.width * .04,
                                top: size.height * .02),
                            child: Text(
                                snapshot.data["contents"]
                                    ["hero_section_vesicle_insurance"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 6,
                                style: TextStyle(
                                    fontSize: size.height * .02,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Spacer(),
                          Padding(
                              padding: EdgeInsets.only(
                                left: size.width * .06,
                                right: size.width * .04,
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "CONTACT US  >>",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .02),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
                //Slider Container properties
                options: CarouselOptions(
                  aspectRatio: 1.3,
                  scrollPhysics: BouncingScrollPhysics(),
                  autoPlay: true,
                ),
              ),
            );
          } else {
            return Text("No productt found");
          }
        },
      ),
    );
  }
}
