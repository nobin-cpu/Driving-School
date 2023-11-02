import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:http/http.dart' as http;
import '../../App/appurls.dart';

class UpcomingBooking extends StatefulWidget {
  const UpcomingBooking({Key? key}) : super(key: key);

  @override
  State<UpcomingBooking> createState() => _UpcomingBookingState();
}

class _UpcomingBookingState extends State<UpcomingBooking> {
  String user = "";

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
        await http.get(Uri.parse(Appurl.ongoing), headers: requestHeaders);
    if (response.statusCode == 200) {
      print("get it==============");
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    } else {
      print(token);
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
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                            itemCount: snapshot.data["bookings"].length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                child: Container(
                                  height: size.height * .14,
                                  width: double.infinity,
                                  child: Card(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * .0,
                                              left: size.width * .06),
                                          child: CircleAvatar(
                                            maxRadius: size.height * .035,
                                            backgroundColor: Color(0xFF198754),
                                            child: Icon(
                                              Icons.calendar_month_outlined,
                                              color: Colors.white,
                                              size: size.height * .04,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: size.height * .02,
                                                  left: size.width * .07),
                                              child: Text(
                                                "22-Jun-2023",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Color(0xFF198754),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: size.height * .015,
                                                  left: size.width * .07),
                                              child: Text(
                                                "03-Jun-2023 to 03-Jun-2023",
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }))
                      ],
                    );
                  } else {
                    return  Image.asset(
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
