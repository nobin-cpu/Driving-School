import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s/drawerpages/bookings/change_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../../App/appurls.dart';

class OngoingBookingDetails extends StatefulWidget {
  final String title, haslicence, carType, bokingId, instructorId;
  final int price;
  final int courseHour;
  final int timeLimit;

  const OngoingBookingDetails({
    Key? key,
    required this.title,
    required this.price,
    this.timeLimit = 0,
    required this.haslicence,
    required this.carType,
    required this.bokingId,
    required this.courseHour,
    required this.instructorId,
  }) : super(key: key);

  @override
  State<OngoingBookingDetails> createState() => _OngoingBookingDetailsState();
}

class _OngoingBookingDetailsState extends State<OngoingBookingDetails> {
  String tokens = "";
  Future cancelBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.cancelBooking),
    );
    request.fields.addAll({
      'booking_id': widget.bokingId,
    });

    // if (_image != null) {
    //   request.files
    //       .add(await http.MultipartFile.fromPath('attached_file', _image.path));
    // }

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          setState(() {
            Get.back();
            tokens = token.toString();
          });
        } else {
          // print(title);
          print(response.body.toString());

          return response.body;
        }
      });
    });
  }

  Future completedBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.completedBooking),
    );
    request.fields.addAll({
      'booking_id': widget.bokingId,
    });

    // if (_image != null) {
    //   request.files
    //       .add(await http.MultipartFile.fromPath('attached_file', _image.path));
    // }

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          setState(() {
            Get.back();
          });
        } else {
          // print(title);
          print(response.body.toString());

          return response.body;
        }
      });
    });
  }

  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? usertype = prefs.getString('type');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.ongoing2), headers: requestHeaders);
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
      appBar: AppBar(
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
          IconButton(
              onPressed: () {
                print(widget.timeLimit);
              },
              icon: Icon(Icons.abc))
        ],
      ),
      body: SingleChildScrollView(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: size.width),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text("Course: "),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Title: ",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 210,
                                          child: Text(
                                            snapshot.data[0]["course"]["title"]
                                                .toString(),
                                            maxLines: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(snapshot.data[0]["course"]["price"]
                                          .toString()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: size.width),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text("Has Provisional Licence"),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Row(
                                      children: [
                                        Text(
                                          snapshot.data[0]
                                                  ["has_provisional_licence"]
                                              .toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: size.width),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text("Car Type"),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Row(
                                      children: [
                                        Text(
                                          snapshot.data[0]["car_type"],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 10, left: 13),
                        child: Text(
                          "Booked Scedules",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: size.width),
                      child: Card(
                        child: Column(
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
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length == 0
                                              ? 1
                                              : snapshot.data.length,
                                          itemBuilder: ((context, index) {
                                            if (snapshot.data.length == 0) {
                                              return Center(
                                                child: Image.asset(
                                                  "images/no-data.gif",
                                                ),
                                              );
                                            } else {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                    [
                                                                    "booked_schedule"]
                                                                    [index]
                                                                    ["date"]
                                                                .toString(),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            width: 25,
                                                          ),
                                                          Text(
                                                            "Start: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                    [
                                                                    "booked_schedule"]
                                                                    [index][
                                                                    "start_time"]
                                                                .toString(),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            width: 25,
                                                          ),
                                                          Text(
                                                            "End: ",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                    [
                                                                    "booked_schedule"]
                                                                    [index]
                                                                    ["end_time"]
                                                                .toString(),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          })),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
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
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 45,
                        width: 180,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                            ),
                            onPressed: () {
                              print(widget.courseHour);
                              Get.to(() => ChangeSchedule(
                                  instructorId: widget.instructorId,
                                  courseId: widget.bokingId,
                                  timeLimit:
                                      double.parse(widget.timeLimit.toString()),
                                  token: "$tokens",
                                  price: widget.price.toString()));
                            },
                            child: Text("Change Schedule")),
                      ),
                      SizedBox(
                        height: 45,
                        width: 180,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            onPressed: () {
                              completedBooking();
                            },
                            child: Text("Booking Completed")),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 45,
                        width: 376,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(215, 255, 64, 128),
                            ),
                            onPressed: () {
                              cancelBooking();
                              print(widget.bokingId);
                            },
                            child: Text("Booking Cancel")),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              );
            } else {
              return Image.asset(
                "images/no-data.gif",
              );
            }
          },
        ),
      ),
    );
  }
}
