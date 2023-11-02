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

  late Future<Map<String, dynamic>> _bookingData;

  Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token",
    };

    final response = await http.get(
        Uri.parse(Appurl.ongoing2 + widget.bokingId),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      print("ok");
      var userData1 = jsonDecode(response.body)["data"][0];
      return userData1;
    } else {
      print("Request failed with status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to fetch data'); // Throw an exception here
    }
  }

  Future? home1;
  @override
  void initState() {
    home1 = fetchData();
    _bookingData = fetchData();
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
       
      ),
      body: SingleChildScrollView(
        child: Column(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 210,
                                    child: Text(
                                      widget.title.toString(),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(widget.price.toString()),
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
                                    widget.haslicence.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    widget.carType,
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
                  padding: const EdgeInsets.only(top: 15, bottom: 10, left: 13),
                  child: Text(
                    "Booked Scedules",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
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
                      // FutureBuilder(
                      //   future: home1,
                      //   builder: (context, AsyncSnapshot snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return Center(
                      //         child: buildShimmerEffect(),
                      //       );
                      //     } else if (snapshot.hasError) {
                      //       return Center(
                      //         child: Text("Error fetching data"),
                      //       );
                      //     } else if (!snapshot.hasData ||
                      //         snapshot.data == null ||
                      //         snapshot.data.isEmpty) {
                      //       return Center(
                      //         child: Image.asset("images/no-data.gif"),
                      //       );
                      //     } else {
                      //       var bookingData = snapshot.data[0];
                      //       var bookedSchedules =
                      //           bookingData["booked_schedule"];

                      //       return Column(
                      //         children: [
                      //           const SizedBox(
                      //             height: 20,
                      //           ),
                      //           ListView.builder(
                      //             physics: NeverScrollableScrollPhysics(),
                      //             shrinkWrap: true,
                      //             itemCount: data.length,
                      //             itemBuilder: (context, index) {
                      //               var schedule = bookedSchedules[index];
                      //               var date = schedule["date"];
                      //               var startTime = schedule["start_time"];
                      //               var endTime = schedule["end_time"];

                      //               return Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   Padding(
                      //                     padding: const EdgeInsets.all(8.0),
                      //                     child: FittedBox(
                      //                       fit: BoxFit.cover,
                      //                       child: Row(
                      //                         children: [
                      //                           const SizedBox(
                      //                             width: 15,
                      //                           ),
                      //                           Text(
                      //                             date.toString(),
                      //                             maxLines: 2,
                      //                             overflow:
                      //                                 TextOverflow.ellipsis,
                      //                             style: TextStyle(
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                           SizedBox(
                      //                             width: 25,
                      //                           ),
                      //                           Text(
                      //                             "Start: ",
                      //                             style: TextStyle(
                      //                                 color: Colors.green,
                      //                                 fontSize: 15,
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                           Text(
                      //                             startTime != null
                      //                                 ? startTime.toString()
                      //                                 : 'N/A',
                      //                             maxLines: 2,
                      //                             overflow:
                      //                                 TextOverflow.ellipsis,
                      //                             style: TextStyle(
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                           SizedBox(
                      //                             width: 25,
                      //                           ),
                      //                           Text(
                      //                             "End: ",
                      //                             style: TextStyle(
                      //                                 color: Colors.red,
                      //                                 fontSize: 15,
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                           Text(
                      //                             endTime != null
                      //                                 ? endTime.toString()
                      //                                 : 'N/A',
                      //                             maxLines: 2,
                      //                             overflow:
                      //                                 TextOverflow.ellipsis,
                      //                             style: TextStyle(
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               );
                      //             },
                      //           ),
                      //           const SizedBox(
                      //             height: 20,
                      //           ),
                      //         ],
                      //       );
                      //     }
                      //   },
                      // ),

                      FutureBuilder(
                        future: _bookingData,
                        builder: (context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: buildShimmerEffect(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error fetching data"),
                            );
                          } else if (!snapshot.hasData) {
                            return Center(
                              child: Image.asset("images/no-data.gif"),
                            );
                          } else {
                            var bookingData = snapshot.data!;
                            var bookedSchedules =
                                bookingData["booked_schedule"];

                            return Column(
                              children: [
                                // ... (other widgets)
                                ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: Colors.deepOrange,
                                    );
                                  },
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: bookedSchedules.length,
                                  itemBuilder: (context, index) {
                                    var schedule = bookedSchedules[index];
                                    var date = schedule["date"];
                                    var startTime = schedule["start_time"];
                                    var endTime = schedule["end_time"];

                                    return ListTile(
                                      title: Text("Date: $date"),
                                      subtitle: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Start Time: ${startTime ?? 'N/A'}"),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          Text("End Time: ${endTime ?? 'N/A'}"),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                // ... (other widgets)
                              ],
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
        ),
      ),
    );
  }
}
