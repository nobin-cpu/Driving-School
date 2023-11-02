import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:s/book_a_lesson/signup.dart';
import 'package:s/login/signUo/signup.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../App/appurls.dart';
import '../profile.dart';

class TimeandDate2 extends StatefulWidget {
  String instructorId, courseId, selectdate;
  TimeandDate2(
      {Key? key,
      required this.instructorId,
      required this.courseId,
      required this.selectdate})
      : super(key: key);

  @override
  State<TimeandDate2> createState() => _TimeandDate2State();
}

class _TimeandDate2State extends State<TimeandDate2> {
  String _selectedItem = '';
  String courseIdfrompage = "";

  String selectedItem = "";
  int? selectedIndex;
  List<String> _dropdownItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
  ];

  TextEditingController _dateTimeController = TextEditingController();
  DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateTimeController.text = _dateTimeFormat.format(picked);
      });
    }
  }

  List<String> dataList = [];
  // Future withdraw() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('auth_token');

  //   Map<String, String> requestHeaders = {
  //     'Accept': 'application/json',
  //     // 'authorization': "Bearer $token"
  //   };
  //   var request = await http.MultipartRequest(
  //     'POST',
  //     Uri.parse(Appurl.sentDate),
  //   );
  //   request.fields.addAll({
  //     'booking_id': widget.courseId.toString(),
  //     'instructor_id': widget.instructorId.toString(),
  //     'date': _dateTimeController.text,
  //   });

  //   // if (_image != null) {
  //   //   request.files
  //   //       .add(await http.MultipartFile.fromPath('attached_file', _image.path));
  //   // }

  //   request.headers.addAll(requestHeaders);

  //   request.send().then((result) async {
  //     http.Response.fromStream(result).then((response) {
  //       if (response.statusCode == 200) {
  //         var data = jsonDecode(response.body);

  //         // titlecontroller.clear();
  //         // messagecontroller.clear();
  //         // saveprefs(data["token"]);
  //         // chat.clear();

  //         // Navigator.push(
  //         //     context,
  //         //     MaterialPageRoute(
  //         //         builder: (context) => HomePage(
  //         //           token: data['data']["auth_token"],
  //         //               isLogin: true,
  //         //             )));
  //         setState(() {});
  //       } else {
  //         // print(title);
  //         print(response.body.toString());

  //         return response.body;
  //       }
  //     });
  //   });
  // }

  Future homes() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      // 'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(
            "https://precisiondriving.uk/api/available-time?booking_id=${widget.courseId}&date=${widget.selectdate}"),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected here' + response.body);
      print("1234");
      var userData1 = jsonDecode(response.body)["data"];
      setState(() {
        userData1 = response.body;
      });
      return userData1;
    }
    if (response.statusCode == 401) {
      _showPopUp();
    } else {
      print("12345");
      print("post have no Data${response.body}");
    }
  }

  void _showPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session Expired'),
          content: Text('To continue go to login page'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
              child: Text('Ok'),
              onPressed: () {
                Get.to(() => Logins());
              },
            ),
          ],
        );
      },
    );
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

  Future? home3;
  @override
  void initState() {
    home3 = homes();
    super.initState();
  }

  bool isvisible = false;
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
        // actions: [
        //   Padding(
        //       padding: EdgeInsets.all(10.0),
        //       child: InkWell(
        //         onTap: () {
        //           widget.token != null
        //                 ? Get.to(() => Profile(
        //                       token: widget.token,
        //                     ))
        //                 : Get.to(() => Logins());
        //         },
        //         child: CircleAvatar(
        //           backgroundColor: Color(0xFF198754),
        //           child: Icon(
        //             Icons.person,
        //             color: Colors.white,
        //           ),
        //         ),
        //       ))
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Date ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "*",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _dateTimeController,
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xFF198754),
                          )),
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          labelText: 'Select Date',
                          labelStyle: TextStyle(
                            color: Color(0xFF198754),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Time",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "*",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: home3,
                      builder: (_, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: buildShimmerEffect(),
                          );
                        } else if (snapshot.hasData && isvisible) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data["available_time"]
                                .toString()
                                .length,
                            itemBuilder: (context, index) {
                              return ShowUpAnimation(
                                delayStart: Duration(milliseconds: 400),
                                animationDuration: Duration(milliseconds: 400),
                                offset: 0.9,
                                curve: Curves.linear,
                                direction: Direction.horizontal,
                                child: ListTile(
                                  // tileColor: selectedIndex == index
                                  //     ? Color(0xFF198754)
                                  //     : null,
                                  onTap: () {
                                    // setState(() {
                                    //   courseIdfrompage = snapshot
                                    //       .data["courses"][index]["course_id"]
                                    //       .toString();
                                    //   selectedIndex = index;
                                    //   selectedItem = snapshot.data["courses"]
                                    //           [index]["headline"]
                                    //       .toString();
                                    // });
                                    // print(selectedItem);
                                  },
                                  title: Text(snapshot.data["available_time"]
                                          [index]["date"]
                                      .toString()),
                                  // leading: IconButton(
                                  //     onPressed: () {
                                  //       print(snapshot.data);
                                  //     },
                                  //     icon: Icon(Icons.abc)),
                                ),
                              );
                            },
                          );
                        } else {
                          return Text("00");
                        }
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF198754),
        onPressed: () {
          setState(() {
            isvisible = true;
          });
          homes();
          // withdraw();
          print("thhh" + widget.courseId);
          // Get.to(() => Signupfrombook(
          //       bookingId: widget.courseId,
          //     ));
        },
        child: Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
