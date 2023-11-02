import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:s/courses/courses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart' show precacheImage;

import 'book_a_lesson/book_a_lesson.dart';

class HomeComponents extends StatefulWidget {
  final String token;
  const HomeComponents({Key? key, required this.token}) : super(key: key);

  @override
  State<HomeComponents> createState() => _HomeComponentsState();
}

class _HomeComponentsState extends State<HomeComponents> {
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

  Future? home1;
  @override
  void initState() {
    home1 = homes();

    super.initState();
  }

  late ImageProvider _imageProvider;
  bool _isLoading = true;
  String img = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: double.infinity),
          child: Stack(
            children: [
              FutureBuilder(
                future: home1,
                builder: (_, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: buildShimmerEffect(),
                    );
                  } else if (snapshot.hasData) {
                    img = Appurl.baseURL +
                        snapshot.data["contents"]["hero_section_bg"];
                    return SingleChildScrollView(
                      reverse: true,
                      physics: ScrollPhysics(),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                    maxWidth: double.infinity,
                                    maxHeight: double.infinity),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(Appurl.baseURL +
                                          snapshot.data["contents"]
                                              ["hero_section_bg"])),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: size.height * .03,
                                          top: size.height * .039,
                                        ),
                                        child: Text(
                                          "Best Driving School",
                                          style: TextStyle(
                                              fontSize: size.height * .025,
                                              color: Color.fromARGB(0, 0, 0, 0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.height * .03,
                                            top: size.height * .022,
                                            right: 10),
                                        child: Text(
                                          snapshot.data["contents"]
                                              ["hero_section_card_title"],
                                          style: TextStyle(
                                            fontSize: size.height * .03,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(0, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.height * .03,
                                            top: size.height * .022,
                                            right: 10),
                                        child: Text(
                                          snapshot.data["contents"]
                                              ["hero_section_card_text"],
                                          style: TextStyle(
                                              color: Color.fromARGB(0, 0, 0, 0),
                                              fontSize: size.height * .02,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.height * .024,
                                            top: size.height * .022,
                                            bottom: 20),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(
                                                  0, 255, 255, 255),
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            print("123" + img);
                                            // Get.to(() => BookALesson());
                                          },
                                          child: Text(
                                            "Get Started >",
                                            style: TextStyle(
                                                color:
                                                    Color.fromARGB(0, 0, 0, 0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Image.asset(
                      "images/no-data.gif",
                    );
                  }
                },
              ),

              //do the same word for bg image
              Padding(
                padding: EdgeInsets.only(
                    left: 18, right: 14, top: size.height * .04, bottom: 30),
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: size.width * .92, maxHeight: double.infinity),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(92, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: home1,
                        builder: (_, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: buildShimmerEffect(),
                            );
                          } else if (snapshot.hasData) {
                            return SingleChildScrollView(
                              reverse: true,
                              physics: ScrollPhysics(),
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: size.height * .01,
                                                top: size.height * .014,
                                              ),
                                              child: Text(
                                                "Best Driving School",
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * .025,
                                                    color: Colors.redAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.height * .01,
                                                  top: size.height * .01,
                                                  right: 10),
                                              child: Text(
                                                snapshot.data["contents"]
                                                    ["hero_section_card_title"],
                                                style: TextStyle(
                                                    fontSize: size.height * .03,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.height * .01,
                                                  top: size.height * .022,
                                                  right: 10),
                                              child: Text(
                                                snapshot.data["contents"]
                                                    ["hero_section_card_text"],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: size.height * .02,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.height * .01,
                                                  top: size.height * .022,
                                                  bottom: 20),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color(0xFF198754),
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                onPressed: () {
                                                  print("object" + img);
                                                  Get.to(() => Courses(
                                                        token: widget.token,
                                                        valfordrawer: "1",
                                                      ));
                                                },
                                                child: Text(
                                                  "Get Started >",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          } else {
                            return Image.asset(
                              "images/no-data.gif",
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
