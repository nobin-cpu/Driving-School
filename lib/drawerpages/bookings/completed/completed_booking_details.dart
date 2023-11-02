import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:s/App/appurls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class CompletedOngoingBookingDetails extends StatefulWidget {
  final String title, haslicence, carType, bookingId;
  final int price;

  const CompletedOngoingBookingDetails({
    Key? key,
    required this.title,
    required this.price,
    required this.haslicence,
    required this.carType,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<CompletedOngoingBookingDetails> createState() =>
      _CompletedOngoingBookingDetailsState();
}

class _CompletedOngoingBookingDetailsState
    extends State<CompletedOngoingBookingDetails> {
  late Future<Map<String, dynamic>> _bookingData;

  Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token",
    };

    final response = await http.get(
        Uri.parse(Appurl.ongoing2 + widget.bookingId),
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
                                    widget.carType.toString(),
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
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: _bookingData,
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                  var bookedSchedules = bookingData["booked_schedule"];

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

                          return Card(
                            child: ListTile(
                              title: Text("Date: $date"),
                              subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Start Time: ${startTime ?? 'N/A'}"),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  Text("End Time: ${endTime ?? 'N/A'}"),
                                ],
                              ),
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
    );
  }
}
