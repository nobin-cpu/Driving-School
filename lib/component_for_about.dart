import 'dart:convert';
import 'package:get/get.dart';
import 'package:s/services/instructor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:s/App/appurls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'services/services.dart';

class About extends StatefulWidget {
  final String token;
  const About({Key? key, required this.token}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
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
              return SingleChildScrollView(
                  reverse: true,
                  physics: ScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: double.infinity,
                          maxHeight: double.infinity),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "images/DR.jpg",
                              )),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      child: Stack(children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * .05, left: 30, bottom: 14),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: double.infinity,
                                maxHeight: double.infinity),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              color: Color.fromARGB(170, 0, 0, 0),
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * .05,
                                      top: size.height * .02),
                                  child: Text(
                                    snapshot.data["contents"]
                                        ["about_company_headline"],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.height * .025),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * .05,
                                      top: size.height * .009,
                                      right: 10),
                                  child: Text(
                                    snapshot.data["contents"]
                                        ["about_company_desc"],
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100,
                                        fontSize: size.height * .02),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * .05,
                                      top: size.height * .017,
                                      bottom: 10,
                                      right: 10),
                                  child: SizedBox(
                                    height: 25,
                                    width: size.width * .35,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(),
                                        onPressed: () {
                                          Get.to(() => Services(
                                            token: widget.token,
                                                valfordrawer: "0",
                                              ));
                                        },
                                        child: Text("Find Instructor")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ));
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
